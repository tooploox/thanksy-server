# frozen_string_literal: true

class CreatePostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.jsonb    :author, default: {}
      t.text     :category, default: ""
      t.text     :title, default: ""
      t.text     :text, default: ""
      t.integer  :lifespan, default: 1
      t.datetime :publish_at, default: nil

      t.timestamps
    end
  end
end
