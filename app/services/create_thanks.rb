# frozen_string_literal: true

class CreateThanks
  class UserNotFound < StandardError; end

  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(thanksy_request)
    thank_recivers = extract_recivers(thanksy_request.thanksy_text)
    creator = find_user(thanksy_request.user_name)
    recivers = thank_recivers.map do |user_name|
      find_user_or_group_of_users(user_name)
    end.flatten
    creator.increment!(:thanks_sent)
    recivers.each { |r| r.increment!(:thanks_recived) }
    thanks = create_thanks(creator, recivers, thanksy_request.thanksy_text)
    send_thanksy_to_slack(thanksy_request.response_url, thanksy_request.user_name, thanks)
  rescue UserNotFound => e
    notify_slack_about_error(thanksy_request.response_url, e.message)
  end

  private

  def extract_recivers(thanksy_text)
    thanksy_text.scan(/@([\w.]+)/).flatten
  end

  def find_user_or_group_of_users(name)
    result = find_user(name) || find_group_in_slack(name)
    result.tap do |r|
      raise UserNotFound, "User or group #{name} doesn't exist" if r.blank?
    end
  end

  def find_user(user_name_or_id)
    find_slack_user_in_db_by_name(user_name_or_id) ||
      find_slack_user_in_db_by_id(user_name_or_id) ||
      find_user_in_slack("@#{user_name_or_id}") ||
      find_user_in_slack(user_name_or_id)
  end

  def find_slack_user_in_db_by_name(user_name)
    SlackUser.where(name: user_name).take
  end

  def find_slack_user_in_db_by_id(id)
    SlackUser.where(id: id).take
  end

  def find_user_in_slack(user_name)
    user = @slack_client.users_info(user_name)
    save_user(user) if user
  end

  def find_group_in_slack(name)
    groups = @slack_client.usergroups_list
    if groups
      group = groups[:usergroups].find do |usergroup|
        usergroup[:handle] == name
      end
    end
    group[:users].map { |id| find_user(id) } if group
  end

  def save_user(user)
    SlackUser.create(
      id: user[:user][:id],
      name: user[:user][:name],
      real_name: user[:user][:real_name],
      avatar_url: user[:user][:profile][:image_72],
    )
  end

  def create_thanks(creator, users, text)
    Thanks.create(
      giver: creator.as_json.except("thanks_sent", "thanks_recived"),
      receivers: users.as_json.map { |r| r.except("thanks_sent", "thanks_recived") },
      text: text,
    )
  end

  def send_thanksy_to_slack(response_url, creators_user_name, thanks)
    response = SlackResponse.new.in_channel(creators_user_name, thanks)
    @slack_client.send_thanks_to_channel(response_url, response)
  end

  def notify_slack_about_error(response_url, message)
    @slack_client.send_thanks_to_channel(response_url, text: message)
  end
end
