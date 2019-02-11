# frozen_string_literal: true

class CreateThanks
  class UserNotFound < StandardError; end

  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(thanksy_request)
    receivers = extract_receivers_from_request(thanksy_request.thanksy_text)
    receivers = find_receivers_in_db_or_on_slack(receivers)
    giver = find_user(thanksy_request.user_name)
    thanks = save_aggregate(giver, receivers, thanksy_request)
    send_thanksy_to_slack(thanksy_request.response_url, thanksy_request.user_name, thanks)
  rescue UserNotFound => e
    notify_slack_about_error(thanksy_request.response_url, e.message)
  end

  private

  def find_receivers_in_db_or_on_slack(receivers)
    receivers.map do |user_name|
      find_user_or_group_of_users(user_name)
    end.flatten
  end

  def extract_receivers_from_request(thanksy_text)
    thanksy_text.scan(/@([\w.]+)/).flatten
  end

  def find_user_or_group_of_users(name)
    result = find_user(name) || find_group_in_slack(name)
    result.tap do |r|
      raise UserNotFound, "User or group #{name} doesn't exist" if r.blank?
    end
  end

  def find_user(user_name_or_id)
    find_slack_user_in_db(user_name_or_id) || find_user_in_slack(user_name_or_id)
  end

  def find_slack_user_in_db(user_name_or_id)
    user = find_slack_user_in_db_by_name(user_name_or_id) || find_slack_user_in_db_by_id(user_name_or_id)
    refresh_slack_user_async(user) if user
    user
  end

  def find_user_in_slack(user_name_or_id)
    fetch_slack_user_data("@#{user_name_or_id}") || fetch_slack_user_data(user_name_or_id)
  end

  def find_slack_user_in_db_by_name(user_name)
    SlackUser.find_by(name: user_name)
  end

  def find_slack_user_in_db_by_id(id)
    SlackUser.find_by(id: id)
  end

  def fetch_slack_user_data(user_name)
    user_data = @slack_client.users_info(user_name)
    new_user(user_data) if user_data
  end

  def find_group_in_slack(name)
    usergroups = @slack_client.usergroups_list&.dig(:usergroups)
    group = usergroups.find { |usergroup| usergroup[:handle] == name } if usergroups
    group&.dig(:users)&.map { |id| find_user(id) }
  end

  def new_user(user)
    SlackUser.new(
      id: user[:user][:id],
      name: user[:user][:name],
      real_name: user[:user][:real_name],
      avatar_url: user[:user][:profile][:image_72],
    )
  end

  def save_aggregate(thanks_giver, receivers, thanksy_request)
    ActiveRecord::Base.transaction do
      thanks_giver.increment(:thanks_sent).save!
      receivers.each { |r| r.increment(:thanks_recived).save! }
      create_thanks(thanks_giver, receivers, thanksy_request.thanksy_text)
    end
  end

  def create_thanks(thanks_giver, users, text)
    Thanks.create(
      giver: thanks_giver.as_json.except("thanks_sent", "thanks_recived"),
      receivers: users.as_json.map { |r| r.except("thanks_sent", "thanks_recived") },
      text: text,
    )
  end

  def send_thanksy_to_slack(response_url, thanks_givers_user_name, thanks)
    response = SlackResponse.new.in_channel(thanks_givers_user_name, thanks)
    @slack_client.send_thanks_to_channel(response_url, response)
  end

  def notify_slack_about_error(response_url, message)
    @slack_client.send_thanks_to_channel(response_url, text: message)
  end

  def refresh_slack_user_async(user)
    RefreshSlackUser.perform_async(@slack_client, user)
  end
end
