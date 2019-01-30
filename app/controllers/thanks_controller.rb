# frozen_string_literal: true

class ThanksController < ApplicationController
  before_action :verify_slack_token, except: :index

  def index
    render json: Thanks.order(created_at: :desc).all
  end

  def create
    render json: CreateThanks.new.(params)
  rescue CreateThanks::UserDoesNotExist => e
    render json: e.message
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
