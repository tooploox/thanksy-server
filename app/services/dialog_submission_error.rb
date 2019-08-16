# frozen_string_literal: true

class DialogSubmissionError < StandardError
  attr_reader :payload

  def initialize(payload)
    super("Submission Validation Error")
    @payload = payload
  end
end
