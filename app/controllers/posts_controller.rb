# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def index
    now = DateTime.now
    posts = Post
            .where("
              (publish_start <= ? AND publish_end >= ?)
              OR publish_start >= ?", now, now, now)
            .order_by(:publish_start)
    render json: posts
  end

  def list
    ListPosts.perform_async(params)
    render json: { text: "Listing info posts!" }
  end

  def create
    OpenPostDialog.new.perform(post_params)
    render json: { text: "ok" }
  end

  def destroy
    render json: { text: "Post destroyed" }
  end

  private

  def post_params
    params.permit(:trigger_id, :response_url)
  end
end
