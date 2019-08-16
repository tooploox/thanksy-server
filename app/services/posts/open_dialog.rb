# frozen_string_literal: true

module Posts
  class OpenDialog
    include SuckerPunch::Job

    API = "https://slack.com/api/dialog.open"

    def initialize(slack_client = ::Adapters::Slack.new)
      @slack_client = slack_client
    end

    def perform(params, post = nil)
      trigger_id = params[:trigger_id]
      dialog = if post
                 SlackPostDialog.new.post_edit(trigger_id, post)
               else
                 SlackPostDialog.new.post_add(trigger_id)
               end
      @slack_client.send(API, dialog)
    end
  end
end
