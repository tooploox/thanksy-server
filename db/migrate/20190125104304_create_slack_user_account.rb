# frozen_string_literal: true

class CreateSlackUserAccount < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_users, id: false do |t|
      t.string :id
      t.string :name
      t.string :real_name
      t.string :avatar_url

      t.timestamps
    end

    add_index :slack_users, :id
    add_index :slack_users, :name
  end
end
