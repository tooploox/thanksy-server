# frozen_string_literal: true

class ListPosts
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(params)
    send_posts_to_slack(params, active_and_future_posts)
  end

  private

  def send_posts_to_slack(params, posts)
    response = SlackPostsList.new.(posts)
    @slack_client.send(params[:response_url], response)
  end

  def active_and_future_posts
    now = DateTime.now
    Post
      .where("
        (publish_start <= ? AND publish_end >= ?)
        OR publish_start >= ?", now, now, now)
      .order(:publish_start)
  end
end
