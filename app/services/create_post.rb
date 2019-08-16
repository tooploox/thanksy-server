# frozen_string_literal: true

class CreatePost
  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(payload)
    author = find_author(payload["user"]["name"])
    data = payload["submission"]
    publish_at, publish_end = publication_dates(data)
    create_post(author, publish_at, publish_end, data)
    notify_slack(payload["response_url"], "Post successfully created")
    {}
  rescue FindSlackUsers::SlackUserNotFound => e
    notify_slack(payload["response_url"], e.message)
  rescue ValidationError => e
    { errors: e.payload }
  end

  private

  def publication_dates(payload)
    publish_at = DateTime.parse(payload["post_publish_at"])
    publish_end = publish_at + payload["post_lifespan"].to_i.hours
    [publish_at, publish_end]
  rescue ArgumentError => _
    err = [{ name: "post_publish_at", error: "Date format is not valid." }]
    raise DialogSubmissionError, err
  end

  def create_post(author, publish_start, publish_end, payload)
    Post.create(
      author: author,
      category: payload["post_category"],
      title: payload["post_title"],
      text: payload["post_message"],
      publish_start: publish_start,
      publish_end: publish_end,
    )
  end

  def notify_slack(response_url, message)
    @slack_client.send(response_url, text: message)
  end

  def find_author(name)
    find_slack_users([name]).first
  end

  def find_slack_users(user_names_or_ids)
    FindSlackUsers.new(@slack_client).(user_names_or_ids)
  end
end
