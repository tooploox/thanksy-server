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
    [].new.tap do |i|
      posts.each do |p|
        i << post(p)
      end
    end
  end

  def post(post)
    {
      text: "*post.title*\n#{post.publish_start} - #{post.publish_end}",
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
end
