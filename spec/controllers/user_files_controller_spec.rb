require 'spec_helper'
require 'eventmachine'

Spec::Matchers.define :exist_in_database do

  match do |actual|
    actual.class.exists?(actual.id)
  end

end


describe UserFilesController do
  fixtures :users, :user_files
  def file_attachment
    test_document = "#{Rails.root}/spec/assets/attachments/Example.ogg"
    Rack::Test::UploadedFile.new(test_document, "audio/ogg")
  end

  describe "POST to #create" do
    before do
      sign_in users(:foo)
      post :create, :user_file => {:name =>
                                     fixture_file_upload("/test.mp3", "audio/mp3") }
    end
    it "Upload" do
      expect(response).to redirect_to(users(:foo))
    end
  end


  describe "Worker" do
    it "Convert" do
      sign_in users(:foo)
      post :create, :user_file => {:name =>
                                       fixture_file_upload("/test.mp3", "audio/mp3") }
      file_ext = '.mp3'
      file_name = 'test'
      unique_name = SecureRandom.uuid
      output_format = APP_CONFIG['audio_output_format']
      input_file_name = Rails.root.join('public', 'uploads', file_name).to_s
      output_file_name = Rails.root.join('public', 'uploads', unique_name).to_s

      file = UserFile.first
      file.should exist_in_database

      file.file_name = unique_name
      file.input_format = file_ext
      file.output_format = output_format
      file.user = users(:foo)
      file.content_type = "audio/mp3"
      file.status = 'queued'
      file.reload

      file_info = {
          "input_file_path" => {"path" => input_file_name},
          "ext" => file_ext,
          "output_file_path" => {"path" => output_file_name},
          "output_format" => output_format,
          "converted_file_name" => unique_name

      }
      ConvertWorker.new.perform(file_info)
      file.status.should == 'uploaded'

      #expect do
      #  Thread.new { EM.run } unless EM.reactor_running?
      #  Thread.pass until EM.reactor_running?
      #
      #  client = Faye::Client.new('http://localhost:9292/faye')
      #  array = []
      #
      #  client.subscribe('/files/new') do |message|
      #    array[] = message.inspect
      #  end
      #end.to change(array, :lenght).by(1)



    end

  end
end
