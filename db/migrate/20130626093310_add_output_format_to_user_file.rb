class AddOutputFormatToUserFile < ActiveRecord::Migration
  def change
    add_column :user_files, :output_format, :string
  end
end
