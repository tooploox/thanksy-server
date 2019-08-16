# frozen_string_literal: true

module SlackResponses
  module Posts
    class Index
      def call
        {
          text: "",
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
            name: "list",
            text: ":file_cabinet: Show active and future posts",
            type: "button",
          },
          {
            name: "add",
            text: ":heavy_plus_sign: Create new post",
            type: "button",
          },
        ]
      end
    end
  end
end
