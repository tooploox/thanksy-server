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
    out += "ID  |  Category | Title  |  Author  | PublishAt | PublishedTill \n"
    posts.each do |p|
      out += "#{p.id} | #{p.category} | *#{p.title}* | #{p.author['name']} | #{p.publish_start.strftime('%F %H:%M')} | #{p.publish_end.strftime('%F %H:%M')} \n"
    end
    out
  end
end
