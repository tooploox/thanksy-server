# frozen_string_literal: true

class Post < ApplicationRecord
  after_initialize :default_values
  self.primary_key = "id"

  DEFAULT_LIFESPAN = 1.day

  def active?
    (publish_start..publish_end).cover?(DateTime.now)
  end

  def self.active_and_future_posts
    now = DateTime.now
    where("
        (publish_start <= ? AND publish_end >= ?)
        OR publish_start >= ?", now, now, now)
      .order(:publish_start)
  end

  def self.active
    where("publish_start <= ? AND publish_end >= ?", DateTime.now, DateTime.now)
      .order(:publish_start)
  end

  private

  def default_values
    self.publish_start ||= DateTime.now
    self.publish_end ||= DateTime.now + DEFAULT_LIFESPAN
  end
end
