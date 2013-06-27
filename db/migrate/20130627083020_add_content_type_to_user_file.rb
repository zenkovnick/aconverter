class AddContentTypeToUserFile < ActiveRecord::Migration
  def change
    add_column :user_files, :content_type, :string
  end
end
