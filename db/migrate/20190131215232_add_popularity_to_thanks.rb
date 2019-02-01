# frozen_string_literal: true

class AddPopularityToThanks < ActiveRecord::Migration[5.2]
  def change
    add_column :thanks, :popularity, :integer, default: 0
  end
end
