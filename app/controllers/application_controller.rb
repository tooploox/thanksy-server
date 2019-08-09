# frozen_string_literal: true

class ApplicationController < ActionController::API

  def verify_access_token
    bearer_token = request.headers[:authorization].to_s.match(/^Bearer (.+)/).to_a[1]

    if ENV["AUTH_TOKEN"].nil?
      render json: {
        error: "You have to set the auth token as an environmental variable called AUTH_TOKEN.",
      }, status: 401
    elsif bearer_token != ENV["AUTH_TOKEN"]
      render json: { error: "You have to provide a valid access token." }, status: 401
    end
  end

  def verify_slack_token
    unless params["token"] == ENV["SLACK_TOKEN"] ||
        JSON.parse(params["payload"])["token"] == ENV["SLACK_TOKEN"]
      render json: "Invalid slack token. Contact with support please!"
    end
  end
end
