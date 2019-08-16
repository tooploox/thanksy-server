# frozen_string_literal: true

module SlackResponses
  module Posts
    class Index
      def call
        {
          text: "*Posts:*",
        }
      end
    end
  end
end
