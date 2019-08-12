# frozen_string_literal: true

class CallbacksController < ApplicationController
  # before_action :verify_slack_token

  def dispach
    puts "AAA"
    # HandleCallback.new.(params)
    puts "AAA"
    render json: { text: "ok" }
  end
end
