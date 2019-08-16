# frozen_string_literal: true

class CallbacksController < ApplicationController
  before_action :verify_slack_token

  def exec
    data = HandleCallback.new.(params)
    if data.empty?
      # Slack Dialogs: to close dialog send status :ok with empty body
      head :ok, content_type: "application/json"
    else
      render json: data
    end
  end
end
