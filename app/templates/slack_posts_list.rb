# frozen_string_literal: true

class SlackPostsList
  def call(posts)
    {
      text: "*Active and future posts:*",
      attachments: list(posts),
    }
  end

  private

  def list(posts)
    [].tap do |i|
      posts.each do |p|
        i << post(p)
      end
    end
  end

  def post(post)
    {
      text: info(post),
      fallback: "You are unable to do it, sorry",
      callback_id: "post_actions",
      color: "#e5e5e5",
      attachment_type: "default",
      actions: actions(post),
    }
  end

  def actions(post)
    [
      {
        name: "love",
        text: ":heart: lol",
        type: "button",
        value: post.id,
      },
    ]
  end

  def info(post)
    "*#{post.category}*\n"\
      "*#{post.title}*\n"\
      "#{post.publish_start.strftime('%F %H:%M')} - "\
      "#{post.publish_end.strftime('%F %H:%M')}"\
  end
end
