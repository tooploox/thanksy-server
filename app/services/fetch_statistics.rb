# frozen_string_literal: true

class FetchStatistics
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(params)
    thanks_sent_top_user = fetch_slack_user("thanks_sent")
    thanks_recived_top_user = fetch_slack_user("thanks_recived")
    most_reacted_thanks = fetch_thanks("popularity")
     send_thanksy_to_slack(params, thanks_sent_top_user, thanks_recived_top_user, most_reacted_thanks)
  end

  private

  def fetch_slack_user(order_by)
    SlackUser.order("#{order_by} DESC").first
  end

  def fetch_thanks(order_by)
    Thanks.order("#{order_by} DESC").first
  end

  def send_thanksy_to_slack(params, thanks_sent_top_user, thanks_recived_top_user, most_reacted_thanks)
    response = {
      "text": "Stats!",
      "attachments": [
        {
          "title": "User who thanked the most",
          "text": "#{thanks_sent_top_user.name}. Number of sent thanks: #{thanks_sent_top_user.thanks_sent}",
        },
        {
          "title": "User who received most thanks",
          "text": "#{thanks_recived_top_user.name}. Number of recived thanks: #{thanks_sent_top_user.thanks_sent}",
        },
        {
          "title": "The most reacted thanks",
          "text": "`#{most_reacted_thanks.text}`. Number of reactions: #{most_reacted_thanks.popularity}",
        },
      ],
    }
    @slack_client.send_thanks_to_channel(params[:response_url], response)
  end
end
