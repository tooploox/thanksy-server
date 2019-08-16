# frozen_string_literal: true

class HandlePostActions
  attr_reader :trigger_id, :response_url

  def call(payload)
    @trigger_id = payload["trigger_id"]
    @response_url = payload["response_url"]

    payload["actions"].each do |action|
      handle(action)
    end
    {}
  end

  private

  def handle(action)
    case action["name"].to_sym
    when :list
      Posts::List.perform_async(params)
    when :open_add_dialog
      Posts::OpenDialog.perform_async(params)
    end
  end

  def params
    { trigger_id: trigger_id, response_url: response_url }
  end

  # def notify_slack(message)
  #   @slack_client.send(@response_url, text: message)
  # end
end
