# frozen_string_literal: true

class CallbacksController < ApplicationController
  before_action :verify_slack_token

  def exec
    HandleCallback.new.(params)
    render json: { ok: true }
  end
end
