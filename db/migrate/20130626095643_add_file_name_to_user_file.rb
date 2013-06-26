class AddFileNameToUserFile < ActiveRecord::Migration
  def change
    add_column :user_files, :file_name, :string
  end
end
