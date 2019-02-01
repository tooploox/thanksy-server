# frozen_string_literal: true

class FetchStatistics
  def call(_params)
    thanks_sent_top_user = fetch_slack_user("thanks_sent")
    thanks_recived_top_user = fetch_slack_user("thanks_recived")
    most_reacted_thanks = fetch_thanks("popularity")
    {
      "response_type": "in_channel",
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
  end

  private

  def fetch_slack_user(order_by)
    SlackUser.order("#{order_by} DESC").first
  end

  def fetch_thanks(order_by)
    Thanks.order("#{order_by} DESC").first
  end
end
