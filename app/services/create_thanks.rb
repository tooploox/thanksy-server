# frozen_string_literal: true

class CreateThanks
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(thanksy_request)
    receivers = find_slack_users(extract_receivers_from_request(thanksy_request.thanksy_text))
    giver = find_giver(thanksy_request.user_name)
    thanks = save_aggregate(giver, receivers, thanksy_request)
    send_thanksy_to_slack(thanksy_request.response_url, thanksy_request.user_name, thanks)
  rescue FindSlackUsers::SlackUserNotFound => e
    notify_slack_about_error(thanksy_request.response_url, e.message)
  end

  private

  def find_slack_users(user_names_or_ids)
    FindSlackUsers.new(@slack_client).(user_names_or_ids)
  end

  def find_giver(giver_name)
    find_slack_users([giver_name]).first
  end

  def extract_receivers_from_request(thanksy_text)
    thanksy_text.scan(/@([\w.]+)/).flatten
  end

  def save_aggregate(thanks_giver, receivers, thanksy_request)
    ActiveRecord::Base.transaction do
      thanks_giver.increment(:thanks_sent).save!
      receivers.each { |r| r.increment(:thanks_received).save! }
      create_thanks(thanks_giver, receivers, thanksy_request.thanksy_text)
    end
  end

  def create_thanks(thanks_giver, users, text)
    Thanks.create(
      giver: thanks_giver.as_json.except("thanks_sent", "thanks_received"),
      receivers: users.as_json.map { |r| r.except("thanks_sent", "thanks_received") },
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
end
