# frozen_string_literal: true

class ThanksController < ApplicationController
  before_action :verify_slack_token, except: :index

  def index
    render json: Thanks.order(created_at: :desc).all
  end

  def stats
    render json: FetchStatistics.new.(params)
  end

  def create
    CreateThanks.perform_async(params)
    render json: { text: "Processing thanks!" }
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
