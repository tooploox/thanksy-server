# frozen_string_literal: true

class SlackPostDialog
  def post_add(trigger_id)
    {
      trigger_id: trigger_id,
      dialog: {
        callback_id: "post_add",
        title: "Add post",
        submit_label: "Create",
        notify_on_cancel: true,
        state: "new",
        elements: elements(Post.new),
      },
    }
  end

  def post_edit(trigger_id, post)
    {
      trigger_id: trigger_id,
      dialog: {
        callback_id: "post_edit",
        title: "Edit post",
        submit_label: "Update",
        notify_on_cancel: true,
        state: post.id,
        elements: elements(post),
      },
    }
  end

  private

  def elements(post)
    [
      category(post.category),
      title(post.title),
      publish_date(post.publish_start.strftime("%F %H:%M")),
      lifespan(((post.publish_end - post.publish_start) / 1.hour).round),
      message(post.text),
    ]
  end

  def category(value)
    {
      type: "select",
      label: "Category",
      name: "post_category",
      value: value,
      options: [
        {
          label: "Reminder",
          value: "reminder",
        },
        {
          label: "Event",
          value: "event",
        },
        {
          label: "Urgent",
          value: "urgent",
        },
        {
          label: "Info",
          value: "info",
        },
      ],
    }
  end

  def title(value)
    {
      type: "text",
      label: "Title",
      name: "post_title",
      value: value,
    }
  end

  def publish_date(value)
    {
      type: "text",
      label: "Publish date",
      name: "post_publish_at",
      value: value,
      hint: "YYYY-MM-DD HH:MM",
    }
  end

  def lifespan(value)
    {
      type: "text",
      subtype: "number",
      label: "Lifespan",
      name: "post_lifespan",
      value: value,
      hint: "In hours.",
    }
  end

  def message(value)
    {
      type: "textarea",
      label: "Message",
      name: "post_message",
      value: value
    }
  end
end
