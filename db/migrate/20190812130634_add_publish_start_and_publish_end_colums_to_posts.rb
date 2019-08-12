# frozen_string_literal: true

class AddPublishStartAndPublishEndColumsToPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :publish_at
    add_column :posts, :publish_start, :datetime
    add_column :posts, :publish_end, :datetime
  end
end
