# frozen_string_literal: true

class SlackPostsList

  def call(posts)
    {
      "text": list(posts),
    }
  end

  private

  def list(posts)
    out = "*Active Posts:* \n"
    out += "ID  |  Title  |  Author  | PublishAt | PublishedTill \n"
    posts.each do |p|
      out += "*#{p.id}* | *#{p.title}* | #{p.author['name']} | #{p.publish_start} | #{p.publish_end} \n"
    end
    out
  end
end
