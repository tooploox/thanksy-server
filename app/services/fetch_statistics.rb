# frozen_string_literal: true

class FetchStatistics
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(params)
    top_senders = fetch_slack_user("thanks_sent")
    top_receivers = fetch_slack_user("thanks_received")
    most_reacted_thanks = fetch_thanks("popularity")
    send_thanksy_to_slack(params, top_senders, top_receivers, most_reacted_thanks)
  end

  private

  def fetch_slack_user(order_by)
    SlackUser.order("#{order_by} DESC").limit(3)
  end

  def fetch_thanks(order_by)
    Thanks.order("#{order_by} DESC").limit(3)
  end

  def send_thanksy_to_slack(params, top_senders, top_receivers, most_reacted_thanks)
    response = SlackResponse.new.stats(top_senders, top_receivers, most_reacted_thanks)
    @slack_client.send_thanks_to_channel(params[:response_url], response)
  end
end
