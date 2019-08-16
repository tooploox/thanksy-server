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
    when :add
      Posts::OpenDialog.perform_async(params)
    when :edit
      Posts::OpenDialog.perform_async(params.merge(id: action["value"]))
    when :destroy
      Posts::Destroy.perform_async(params.merge(id: action["value"]))
    end
  end

  def params
    { trigger_id: trigger_id, response_url: response_url }
  end
end
