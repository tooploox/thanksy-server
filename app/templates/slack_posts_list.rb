# frozen_string_literal: true

class SlackPostsList

  def call(posts)
    {
      "text": list(posts),
    }
  end

  private

  def list(posts)
    out = "<b>Active Posts:</b> \n"
    posts.each do |p|
      out += "#{p.id} | #{p.title} | #{p.publish_start} \n"
    end
    out
  end
end
