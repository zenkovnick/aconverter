class AddIsActiveToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :is_active, :boolean, :default => false
  end
end
