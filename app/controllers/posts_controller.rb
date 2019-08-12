# frozen_string_literal: true

class PostsController < ApplicationController
  # before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def index
    render json: active_posts
  end

  def list
    if params["text"].&to_i.&positive?
      post = Post.find(params["text"].to_i)
      if post
        OpenPostDialog.new.edit(post_params[:trigger_id], post)
        render json: { text: "Editing post #{post.title}" }
      else
        render json: { ok: false, text: "Post with ID #{post.title} not found" }
      end
    else
      ListPosts.perform_async(params)
      render json: { text: "Listing info posts!" }
    end
  end

  def create
    OpenPostDialog.new.add(post_params[:trigger_id])
    render json: { text: "ok" }
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
