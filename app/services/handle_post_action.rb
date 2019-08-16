# frozen_string_literal: true

class HandlePostAction
  def call(payload)
    puts "handle actions"
    act = payload["actions"].first
    post = Post.find_by_id(act["value"].to_i)
    action = act["name"]
    if action.to_sym == :destroy
      post.destroy
      {}
    else
      OpenPostDialog.new.edit(payload["trigger_id"], post)
    end
  end
end
