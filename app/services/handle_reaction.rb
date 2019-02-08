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
      increment_reaction(thanks, :love_count)
    when "clap"
      increment_reaction(thanks, :clap_count)
    when "confetti"
      increment_reaction(thanks, :confetti_count)
    when "wow"
      increment_reaction(thanks, :wow_count)
    else
      "I have no idea what to do with that."
    end
  end

  def increment_reaction(thanks, reaction_name)
    ActiveRecord::Base.transaction do
      thanks.increment!(reaction_name)
      thanks.increment!(:popularity)
    end
  end
end
