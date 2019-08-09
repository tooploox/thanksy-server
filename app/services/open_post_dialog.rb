# frozen_string_literal: true

class OpenPostDialog

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(post_params)
    send_dialog_to_slack(post_params[:response_url], post_params[:trigger_id])
  end

  private

  def send_dialog_to_slack(response_url, trigger_id)
    dialog = {
      "trigger_id": trigger_id,
      "dialog": {
        "callback_id": "post-add-#{SecureRandom.uuid}",
        "title": "Add a post",
        "submit_label": "Post",
        "notify_on_cancel": true,
        "state": "Limo",
        "elements": [
          {
            "type": "text",
            "label": "Post title",
            "name": "post_title",
          },
          {
            "type": "text",
            "label": "Post date",
            "name": "post_scheduled_at",
          },
        ],
      },
    }
    puts dialog
    puts response_url
    puts trigger_id
    @slack_client.send(response_url, dialog)
  end
end
