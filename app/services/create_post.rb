# frozen_string_literal: true

class CreatePost
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(payload)
    puts "add post"
    puts YAML.dump(author)
    puts YAML.dump(payload)

    author = find_author(payload["user"]["name"])
    publish_at = DateTime.parse(payload["post_publish_at"])
    publish_end = publish_at + payload["lifespan"].to_i.hours
    create_post(author, publish_at, publish_end, payload)
  rescue FindSlackUsers::SlackUserNotFound => e
    notify_slack_about_error(payload[:response_url], e.message)
  end

  private

  def create_post(author, publish_start, publish_end, payload)
    Post.create(
      author: author,
      category: payload["post_category"],
      title: payload["title"],
      text: payload["text"],
      publish_start: publish_start,
      publish_end: publish_end,
    )
  end

  def notify_slack_about_error(response_url, message)
    @slack_client.send(response_url, text: message)
  end

  def find_author(giver_name)
    find_slack_users([giver_name]).first
  end

  def find_slack_users(user_names_or_ids)
    FindSlackUsers.new(@slack_client).(user_names_or_ids)
  end
end
