# frozen_string_literal: true

module SlackResponses
  module Posts
    class Index
      def call
        {
          text: "*Posts:*",
          actions: actions,
        }
      end

      private

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
