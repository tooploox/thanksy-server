# frozen_string_literal: true

module SlackResponses
  module Posts
    class Index
      def call
        {
          text: "*Posts:*",
          attachments: buttons,
        }
      end

      private

      def buttons
        [
          {
            text: "",
            fallback: "You are unable to do it, sorry",
            callback_id: "post_actions",
            color: "#228B22",
            attachment_type: "default",
            actions: actions,
          },
        ]
      end

      def actions
        [
          {
            name: "edit",
            text: ":pencil2: Edit",
            type: "button",
            value: "1234",
          },
        ]
      end
    end
  end
end
