# frozen_string_literal: true

class OpenPostDialog

  API = "https://slack.com/api/dialog.open"

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def add(trigger_id)
    dialog = SlackPostDialog.new.post_add(trigger_id)
    @slack_client.send(API, dialog)
  end

  def edit(trigger_id, post)
    dialog = SlackPostDialog.new.post_edit(trigger_id, post)
    @slack_client.send(API, dialog)
  end
end
