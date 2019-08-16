# frozen_string_literal: true

class PostsController < ApplicationController
  # before_action :verify_access_token, only: :index
  before_action :verify_slack_token, except: :index

  def index
    render json: Post.active
  end

  def index_for_slack
    Posts::Index.perform_async(params)
    head :ok
  end
end
