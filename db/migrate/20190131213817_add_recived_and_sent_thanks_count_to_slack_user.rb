class AddRecivedAndSentThanksCountToSlackUser < ActiveRecord::Migration[5.2]
  def change
    add_column :slack_users, :thanks_sent, :integer, default: 0
    add_column :slack_users, :thanks_recived, :integer, default: 0
  end
end
