# frozen_string_literal: true

class OpenPostDialog

  API = "https://slack.com/api/dialog.open"

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(post_params)
    send_dialog_to_slack(post_params[:trigger_id])
  end

  private

  def send_dialog_to_slack(trigger_id)
    dialog = ::SlackPostDialog.new.post_add(trigger_id)
    @slack_client.send(API, dialog)
  end
end
