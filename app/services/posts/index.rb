# frozen_string_literal: true

module Posts
  class Index
    include SuckerPunch::Job

    def initialize(slack_client = ::Adapters::Slack.new)
      @slack_client = slack_client
    end

    def perform(params)
      send_to_slack(params)
    end

    private

    def send_posts_to_slack(params)
      response = SlackResponses::Posts::Index.new.()
      @slack_client.send(params[:response_url], response)
    end
  end
end
