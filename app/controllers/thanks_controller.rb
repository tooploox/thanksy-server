# frozen_string_literal: true

class ThanksController < ApplicationController
  before_action :verify_access_token, only: :index
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

  # TODO: remove it
  # def update
  #   render json: HandleReaction.new.(params)
  # end
end
