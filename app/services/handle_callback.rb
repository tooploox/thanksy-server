# frozen_string_literal: true

class HandleCallback

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
      puts "UnknownCallbackType #{payload['type']}"
    end
  end

  def handle_interactive_message(payload)
    case payload["callback_id"].to_sym
    when :thanksy_response
      HandleReaction.new.(payload)
    else
      puts "UnknownCallbackId #{payload['callback_id']} for interactive_message"
    end
  end

  def handle_dialog(payload)
    case payload["callback_id"].to_sym
    when :post_add
      HandleAddPost.new.(payload)
    when :post_edit
      HandleEditPost.new.(payload)
    else
      puts "UnknownCallbackId #{payload['callback_id']} for dialog_submission"
    end
  end
end
