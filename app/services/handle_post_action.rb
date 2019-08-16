# frozen_string_literal: true

class HandlePostAction
  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def call(payload)
    @response_url = payload["response_url"]
    act = payload["actions"].first
    post = Post.find_by_id(act["value"].to_i)
    action = act["name"]
    if action.to_sym == :destroy
      post.destroy
      notify_slack("Post #{post.id}:#{post.title} successfully destroyed.")
    else
      OpenPostDialog.new.edit(payload["trigger_id"], post)
    end
    {}
  end

  private

  def notify_slack(message)
    @slack_client.send(@response_url, text: message)
  end
end
