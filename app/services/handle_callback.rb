# frozen_string_literal: true

class HandleCallback

  def initialize(slack_client = ::Adapters::Slack.new)
    @slack_client = slack_client
  end

  def call(params)
    payload = JSON.parse(params["payload"])
    @response_url = payload["response_url"]
    handle(payload)
  end

  private

  def handle(payload)
    case payload["type"].to_sym
    when :interactive_message
      handle_interactive_message(payload)
    when :dialog_submission
      handle_dialog(payload)
    when :dialog_cancellation
      { ok: true }
    else
      logger.warn "UnknownCallbackType #{payload['type']}"
      {}
    end
  end

  def handle_interactive_message(payload)
    case payload["callback_id"].to_sym
    when :thanksy_response
      HandleReaction.new.(payload)
    else
      logger.warn "UnknownCallbackId #{payload['callback_id']} for interactive_message"
    end
  end

  def handle_dialog(payload)
    case payload["callback_id"].to_sym
    when :post_add
      CreatePost.new.perform(payload)
    when :post_edit
      UpdatePost.new.perform(payload)
    else
      logger.warn "UnknownCallbackId #{payload['callback_id']} for dialog_submission"
    end
  end

  def logger
    Rails.logger
  end
end
