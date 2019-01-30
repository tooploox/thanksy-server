# frozen_string_literal: true

class CreateThanksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :thanks do |t|
      t.jsonb   :giver, default: {}
      t.jsonb   :receivers, default: {}
      t.integer :love_count, default: 0
      t.integer :confetti_count, default: 0
      t.integer :clap_count, default: 0
      t.integer :wow_count, default: 0
      t.text    :text

      t.timestamps
    end
  end
end
