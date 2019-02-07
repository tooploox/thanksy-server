# frozen_string_literal: true

class ThanksController < ApplicationController
  before_action :verify_slack_token, except: :index

  def index
    render json: Thanks.order(created_at: :desc).first(10)
  end

  def stats
    FetchStatistics.perform_async(params)
    render json: { text: "Processing stats!" }
  end

  def create
    thanksy_request = ThanksyRequest.new(params.permit(:text, :user_name, :response_url))
    if thanksy_request.valid?
      CreateThanks.perform_async(thanksy_request)
      render json: { text: "Processing thanks! It may take some time for large groups." }
    else
      render json: { text: thanksy_request.errors.full_messages.join(" ") }
    end
  end

  def update
    render json: HandleReaction.new.(params)
  end

  private

  def verify_slack_token
    unless params["token"] == ENV["SLACK_TOKEN"] ||
        JSON.parse(params["payload"])["token"] == ENV["SLACK_TOKEN"]
      render json: "Invalid slack token. Contact with support please!"
    end
  end
end
