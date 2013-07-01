class AddStatusToUserFiles < ActiveRecord::Migration
  def change
    add_column :user_files, :status, :string
  end
end
