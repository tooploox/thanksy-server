# frozen_string_literal: true

module Posts
  class Update
    include SuckerPunch::Job

    def perform(params)
      post = Post.find_by_id(params[:id])
      return unless post

      OpenPostDialog.new.edit(payload["trigger_id"], post)
    end
  end
end
