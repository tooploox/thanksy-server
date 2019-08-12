# frozen_string_literal: true

class CallbacksController < ApplicationController
  before_action :verify_slack_token

  def exec
    render json: HandleCallback.new.(params)
  end
end
