# frozen_string_literal: true

class HandlePostAction
  def call(payload)
    puts "handle actions"
    action = payload["actions"].first
    puts action
    {}
  end
end
