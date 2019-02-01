# frozen_string_literal: true

module TestHelpers
  module_function

  def parsed_body
    JSON.parse(last_response.body, symbolize_names: true)
  end
end
