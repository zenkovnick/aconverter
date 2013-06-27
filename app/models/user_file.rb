class UserFile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :user_id, :input_format, :output_format, :file_name, :content_type
  before_save      UploadWrapper.new
end
