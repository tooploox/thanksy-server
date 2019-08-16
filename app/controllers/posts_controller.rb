# frozen_string_literal: true

class PostsController < ApplicationController
  # before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def index
    render json: active_posts
  end

  def index_for_slack
    Posts::Index.perform_async(params)
    head :ok
  end

  def list
    ListPosts.perform_async(params)
    head :ok, content_type: "application/json"
  end

  def create
    OpenPostDialog.new.add(post_params[:trigger_id])
    head :ok, content_type: "application/json"
  end

  def destroy
    render json: { text: "Post destroyed" }
  end

  private

  def active_posts
    Post
      .where("publish_start <= ? AND publish_end >= ?", DateTime.now, DateTime.now)
      .order(:publish_start)
  end

  def post_params
    params.permit(:trigger_id, :response_url)
  end
end
