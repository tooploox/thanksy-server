# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def create
    puts "Hello"
    OpenPostDialog.new.perform(post_params)
    render json: {}
  end

  private

  def post_params
    params.permit(:trigger_id, :response_url)
  end
end
