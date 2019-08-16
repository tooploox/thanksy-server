# frozen_string_literal: true

module Posts
  class List
    include SuckerPunch::Job

    def initialize(slack_client = ::Adapters::Slack.new)
      @slack_client = slack_client
    end

    def perform(params)
      posts = Post.active_and_future_posts
      response = SlackResponses::Posts::List.new.(posts)
      @slack_client.send(params[:response_url], response)
    end
  end
end
