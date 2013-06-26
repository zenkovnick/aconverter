class AddInputFormatToUserFile < ActiveRecord::Migration
  def change
    add_column :user_files, :input_format, :string
  end
end
