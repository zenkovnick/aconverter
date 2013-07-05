require 'spec_helper'

describe UserFilesController do
  fixtures :users, :user_files
  def file_attachment
    test_document = "#{Rails.root}/spec/assets/attachments/Example.ogg"
    Rack::Test::UploadedFile.new(test_document, "audio/ogg")
  end

  #describe "POST to #create" do
  #  before do
  #    sign_in users(:foo)
  #    post :create, :user_file => {:name =>
  #                                   fixture_file_upload("/test.mp3", "audio/mp3") }
  #  end
  #  it "Upload" do
  #    expect(response).to redirect_to(users(:foo))
  #  end
  #end

  describe "Worker" do
    it "Convert" do
      file_ext = '.ogg'
      file_name = 'Example'
      unique_name = SecureRandom.uuid
      output_format = APP_CONFIG['audio_output_format']
      input_file_name = Rails.root.join('spec', 'fixtures', file_name)
      output_file_name = Rails.root.join('public', 'uploads', unique_name)

      file_info = {
          :input_file_path => input_file_name,
          :ext => file_ext,
          :output_file_path => output_file_name,
          :output_format => output_format,
          :converted_file_name => unique_name

      }
      expect {
        work = ConvertWorker.new
        work.perform(file_info)

      }.to change(ConvertWorker.jobs, :size).by(1)
    end

  end
end