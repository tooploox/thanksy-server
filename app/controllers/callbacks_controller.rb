# frozen_string_literal: true

class CallbacksController < ApplicationController
  before_action :verify_slack_token

  def exec
    # render json: HandleCallback.new.(params)
    # render nothing: true, status: 200
    # render status: :ok
    puts "eho status ok"
    head :ok, content_type: "application/json"
  end
end
