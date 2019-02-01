# frozen_string_literal: true

module Adapters
  class Slack
    def initialize(slack_client = ::Slack::Web::Client.new, conn = Faraday.new)
      @slack_client = slack_client
      @conn = conn
    end

    def users_info(user_name)
      @slack_client.users_info(user: user_name)
    rescue ::Slack::Web::Api::Errors::SlackError
      nil
    end

    def usergroups_list
      @slack_client.usergroups_list(include_users: true)
    rescue ::Slack::Web::Api::Errors::SlackError
      nil
    end

    def send_thanks_to_channel(response_url, response)
      @conn.post do |req|
        req.url response_url
        req.headers["Content-Type"] = "application/json"
        req.body = response.to_json
      end
    end
  end
end
