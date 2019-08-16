# frozen_string_literal: true

module Posts
  class Destroy
    include SuckerPunch::Job

    def initialize(slack_client = ::Adapters::Slack.new)
      @slack_client = slack_client
    end

    def perform(params)
      @response_url = params[:response_url]
      post = Post.find_by_id(params[:id])
      return unless post

      post.destroy
      notify_slack("Post *#{post.title}* successfully destroyed.")
    end

    private

    def notify_slack(message)
      @slack_client.send(@response_url, text: message)
    end
  end
end
