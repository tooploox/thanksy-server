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
      color: post.active? ? "#228B22" : "#e5e5e5",
      attachment_type: "default",
      actions: actions(post),
    }
  end

  def actions(post)
    [
      {
        name: "edit",
        text: ":pencil2: Edit",
        type: "button",
        value: post.id,
      },
      {
        name: "destroy",
        text: ":x: Delete",
        type: "button",
        value: post.id,
        style: "danger",
        confirm: {
          title: "Are you sure?",
          text: "Sit down, relax and think about it",
          ok_text: "Yes",
          dismiss_text: "No",
        },
      },
    ]
  end

  def info(post)
    "*#{post.category.humanize}:* "\
      "#{post.title}\n"\
      "#{post.publish_start.strftime('%F %H:%M')} - "\
      "#{post.publish_end.strftime('%F %H:%M')}"\
  end
end
