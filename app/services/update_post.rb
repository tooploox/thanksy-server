# frozen_string_literal: true

class UpdatePost
  class ValidationError < StandardError
    attr_reader :payload

    def initialize(msg, payload)
      super(msg)
      @payload = payload
    end
  end

  include SuckerPunch::Job

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def perform(payload)
    @response_url = payload["response_url"]
    post_id = payload["state"]&.to_i
    post = Post.find_by_id(post_id)
    if post
      data = payload["submission"]
      if data["post_destroy"] == "yes"
        post.destroy
        notify_slack("Post #{post.id}:#{post.title} successfully destroyed.")
      elsif post.update(post_params(data))
        notify_slack("Post #{post.id}:#{post.title} successfully updated.")
      else
        notify_slack("Error updating Post: #{post.errors}.")
      end
    else
      notify_slack("Could not find Post with ID:#{post.id}.")
    end
    {}
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
    raise ValidationError.new.payload(err)
  end

  def post_params(payload)
    publish_start, publish_end = publication_dates(payload)
    {
      category: payload["post_category"],
      title: payload["post_title"],
      text: payload["post_message"],
      publish_start: publish_start,
      publish_end: publish_end,
    }
  end

  def notify_slack(message)
    @slack_client.send(@response_url, text: message)
  end
end
