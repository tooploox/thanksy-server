# frozen_string_literal: true

class RenameThanksRecivedColumnInSlackUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :slack_users, :thanks_recived, :thanks_received
  end
end
