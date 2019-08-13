# frozen_string_literal: true

class UpdatePost
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(payload)
    puts "edit post"
    post_id = payload["state"]&.to_i
    data = payload["submission"]
    puts post_id
    puts data
    # if data["post_destroy"] == "yes"
    #   post.destroy
    # else
    #   # publish_at, publish_end = publication_dates(data)
    #   # update_post(publish_at, publish_end, data)
    # end
  rescue FindSlackUsers::SlackUserNotFound => e
    notify_slack_about_error(payload[:response_url], e.message)
  end

  private

  def publication_dates(payload)
    publish_at = DateTime.parse(payload["post_publish_at"])
    publish_end = publish_at + payload["post_lifespan"].to_i.hours
    [publish_at, publish_end]
  end

  def update_post(author, publish_start, publish_end, payload)
    Post.create(
      author: author,
      category: payload["post_category"],
      title: payload["post_title"],
      text: payload["post_message"],
      publish_start: publish_start,
      publish_end: publish_end,
    )
  end

  def notify_slack_about_error(response_url, message)
    @slack_client.send(response_url, text: message)
  end
end
