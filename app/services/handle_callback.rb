# frozen_string_literal: true

class HandleCallback
  class UnknownCallbackType < StandardError; end
  class UnknownCallbackId < StandardError; end

  def call(params)
    payload = JSON.parse(params["payload"])
    handle(payload)
  end

  private

  def handle(payload)
    case payload["type"]
    when :interactive_message.to_s
      handle_interactive_message(payload)
    when :dialog_submission.to_s
      handle_dialog(payload)
    else
      raise UnknownCallbackType, "UnknownCallbackType #{payload['type']}"
    end
  end

  def handle_interactive_message(payload)
    case payload["callback_id"]
    when :thanksy_response.to_s
      HandleReaction.new.(payload)
    else
      raise UnknownCallbackId, "UnknownCallbackId #{payload['callback_id']}"
    end
  end

  def handle_dialog(payload)
    case payload["callback_id"]
    when :post_add
      HandleAddPost.new.(payload)
    when :post_edit
      HandleEditPost.new.(payload)
    else
      raise UnknownCallbackId, "UnknownCallbackId #{payload['callback_id']}"
    end
  end
end
