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
        "state": "Limo",
        "elements": elements,
      },
    }
  end

  def post_edit(trigger_id)
    {
      "trigger_id": trigger_id,
      "dialog": {
        "callback_id": "post_edit",
        "title": "Edit post",
        "submit_label": "Update",
        "notify_on_cancel": true,
        "state": "Limo",
        "elements": elements,
      },
    }
  end

  private

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
        "optional": true,
        "name": "post_publish_at",
        "value": DateTime.now.strftime('%F %H:%M'),
      },
      {
        "type": "text",
        "label": "Lifespan (in hours)",
        "name": "post_lifespan",
      },
      {
        "type": "textarea",
        "label": "Message",
        "name": "post_message",
      },
    ]
  end
end
