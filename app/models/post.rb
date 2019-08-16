# frozen_string_literal: true

class Post < ApplicationRecord
  after_initialize :default_values
  self.primary_key = "id"

  DEFAULT_LIFESPAN = 1.day

  def active?
    (publish_start..publish_end).cover?(DateTime.now)
  end

  private

  def default_values
    self.publish_start ||= DateTime.now
    self.publish_end ||= DateTime.now + DEFAULT_LIFESPAN
  end
end
