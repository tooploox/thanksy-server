class RemoveLifespanColumnFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :lifespan
  end
end
