# frozen_string_literal: true

class SlackPostDialog

  def post_add(trigger_id)
    {
      "trigger_id": trigger_id,
      "dialog": {
        "callback_id": "post_add",
        "title": "Add post",
        "submit_label": "Create",
        "notify_on_cancel": true,
        "state": "new",
        "elements": elements,
      },
    }
  end

  def post_edit(trigger_id, post)
    {
      "trigger_id": trigger_id,
      "dialog": {
        "callback_id": "post_edit",
        "title": "Edit post",
        "submit_label": "Update",
        "notify_on_cancel": true,
        "state": post.id,
        "elements": edit_elements(post),
      },
    }
  end

  private

  def edit_elements(post)
    [
      {
        "type": "select",
        "label": "Category",
        "name": "post_category",
        "value": post.category || "",
        "options": [
          {
            "label": "Reminder",
            "value": "reminder",
          },
          {
            "label": "Event",
            "value": "event",
          },
          {
            "label": "Urgent",
            "value": "urgent",
          },
          {
            "label": "Info",
            "value": "info",
          },
        ],
      },
      {
        "type": "text",
        "label": "Title",
        "name": "post_title",
        "value": post.title || "",
      },
      {
        "type": "text",
        "label": "Publish date",
        "hint": "YYYY-MM-DD HH:MM",
        "name": "post_publish_at",
        "value": post.publish_start.strftime("%F %H:%M"),
      },
      {
        "type": "text",
        "subtype": "number",
        "label": "Lifespan (in hours)",
        "name": "post_lifespan",
        "value": (post.publish_end - post.publish_start) / 1.hour,
      },
      {
        "type": "textarea",
        "label": "Message",
        "name": "post_message",
        "value": post.text,
      },
      {
        "type": "select",
        "label": "Delete",
        "name": "post_destroy",
        "optional": true,
        "options": [
          {
            "label": "No",
            "value": "no",
          },
          {
            "label": "Hell no!",
            "value": "no",
          },
          {
            "label": "Yes, destroy",
            "value": "yes",
          },
        ],
      },
    ]
  end

  def elements
    [
      {
        "type": "select",
        "label": "Category",
        "name": "post_category",
        "options": [
          {
            "label": "Reminder",
            "value": "reminder",
          },
          {
            "label": "Event",
            "value": "event",
          },
          {
            "label": "Urgent",
            "value": "urgent",
          },
          {
            "label": "Info",
            "value": "info",
          },
        ],
      },
      {
        "type": "text",
        "label": "Title",
        "name": "post_title",
      },
      {
        "type": "text",
        "label": "Publish date",
        "name": "post_publish_at",
        "value": DateTime.now.strftime("%F %H:%M"),
      },
      {
        "type": "text",
        "subtype": "number",
        "label": "Lifespan (in hours)",
        "name": "post_lifespan",
        "value": 24,
      },
      {
        "type": "textarea",
        "label": "Message",
        "name": "post_message",
      },
    ]
  end
end
