# frozen_string_literal: true

class ListPosts
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(params)
    posts = Post
            .where("publish_start <= ? AND publish_end >= ?", DateTime.now, DateTime.now)
            .order_by(:publish_start)
    send_posts_to_slack(params, posts)
  end

  private

  def send_posts_to_slack(params, posts)
    response = SlackPostsList.new.(posts)
    @slack_client.send(params[:response_url], response)
  end
end
