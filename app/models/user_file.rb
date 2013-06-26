class UserFile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :user_id, :input_format, :output_format, :file_name
  before_save      UploadWrapper.new
  validate :audio_size_validation, :if => "name?"

  def audio_size_validation
    errors[:name] << "should be less than 1MB" if name.size > 1.megabytes
  end
end
