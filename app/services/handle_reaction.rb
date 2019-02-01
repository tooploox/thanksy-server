# frozen_string_literal: true

class HandleReaction
  def call(params)
    thanks_id, action_name, original_message = process_payload(params)
    thanks = find_thanks(thanks_id)
    apply_action(action_name, thanks)
    original_message["attachments"][0]["actions"] = SlackResponse.new.actions(thanks)
    original_message
  end

  private

  def process_payload(params)
    payload = JSON.parse(params["payload"])
    original_message = payload["original_message"]
    action_name = payload["actions"][0]["name"]
    thanks_id = payload["actions"][0]["value"]
    [thanks_id, action_name, original_message]
  end

  def find_thanks(thanks_id)
    Thanks.where(id: thanks_id).take
  end

  def apply_action(action_name, thanks)
    case action_name
    when "love"
      thanks.increment!(:love_count)
      thanks.increment!(:popularity)
    when "clap"
      thanks.increment!(:clap_count)
      thanks.increment!(:popularity)
    when "confetti"
      thanks.increment!(:confetti_count)
      thanks.increment!(:popularity)
    when "wow"
      thanks.increment!(:wow_count)
      thanks.increment!(:popularity)
    else
      "I have no idea what to do with that."
    end
  end
end
