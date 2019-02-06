class LimitTextTo300Characters < ActiveRecord::Migration[5.2]
  def change
    change_column :thanks, :text, :text, limit: 300
  end
end
