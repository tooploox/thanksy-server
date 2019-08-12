# frozen_string_literal: true

class CreatePost
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(payload)
    puts "add post"
    giver = find_giver(payload["user"]["name"])
    puts giver
    puts YAML.dump(payload)
  rescue FindSlackUsers::SlackUserNotFound => e
    notify_slack_about_error(payload[:response_url], e.message)
  end

  private

  def save(payload)
    Post.new(
      author: payload["user"],
      category: payload["post_category"],
      title: payload["title"],
      text: payload["text"],
    )
  end

  def notify_slack_about_error(response_url, message)
    @slack_client.send(response_url, text: message)
  end

  def find_giver(giver_name)
    find_slack_users([giver_name]).first
  end

  def find_slack_users(user_names_or_ids)
    FindSlackUsers.new(@slack_client).(user_names_or_ids)
  end
end
