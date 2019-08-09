# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def create
    File.open("/app/dialog.log", "w") { |file| file.puts YAML.dump(params) }
    dialog = {
      "trigger_id": "13345224609.738474920.8088930838d88f008e0",
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
    render json: dialog
  end
end
