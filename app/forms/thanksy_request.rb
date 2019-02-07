# frozen_string_literal: true

class ThanksyRequest
  include ActiveModel::Model

  def initialize(attributes = {})
    super(user_name: attributes[:user_name], response_url: attributes[:response_url])
    @thanksy_text = filter_thanksy_text(attributes[:text])
  end

  attr_accessor :thanksy_text, :user_name, :response_url

  validates :thanksy_text,
            presence: { message: "can't be empty" },
            length: { maximum: 300, message: "can't be longer than 300 characters" }
  validates :user_name, presence: { message: "can't be empty. Please contact support" }
  validates :response_url, presence: { message: "can't be empty. Please contact support" }

  private

  def filter_thanksy_text(text)
    text.gsub(/<!subteam.+\||>/, "")
  end
end
