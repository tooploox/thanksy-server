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
        "callback_id": "post-add-1234",
        "title": "Add a post",
        "submit_label": "Post",
        "notify_on_cancel": false,
        "state": "Limo",
        "elements": [
          {
            "type": "select",
            "label": "Category",
            "name": "post_category",
            "options": [
              {
                "label": "Reminder",
                "value": "reminder",
              },
              {
                "label": "Event",
                "value": "event",
              },
              {
                "label": "Urgent",
                "value": "urgent",
              },
              {
                "label": "Info",
                "value": "info",
              },
            ],
          },
          {
            "type": "text",
            "label": "Title",
            "name": "post_title",
          },
          {
            "type": "text",
            "label": "Publish date",
            "name": "post_publish_at",
          },
          {
            "type": "text",
            "label": "Lifespan (in hours)",
            "name": "post_lifespan",
          },
          {
            "type": "text",
            "label": "Message",
            "name": "post_message",
          },
        ],
      },
    }
    puts dialog
    puts response_url
    puts trigger_id
    u = "https://slack.com/api/dialog.open"
    # @slack_client.send(response_url, dialog)
    @slack_client.send(u, dialog)
  end
end
