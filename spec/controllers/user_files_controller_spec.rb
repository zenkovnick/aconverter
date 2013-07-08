require 'spec_helper'
require 'eventmachine'
require 'faye'

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
    #it "Convert" do
    #  sign_in users(:foo)
    #  post :create, :user_file => {:name =>
    #                                   fixture_file_upload("/test.mp3", "audio/mp3") }
    #  file_ext = '.mp3'
    #  file_name = 'test'
    #  unique_name = SecureRandom.uuid
    #  output_format = APP_CONFIG['audio_output_format']
    #  input_file_name = Rails.root.join('public', 'uploads', file_name).to_s
    #  output_file_name = Rails.root.join('public', 'uploads', unique_name).to_s
    #
    #  file = UserFile.first
    #  file.should exist_in_database
    #
    #  file.file_name = unique_name
    #  file.input_format = file_ext
    #  file.output_format = output_format
    #  file.user = users(:foo)
    #  file.content_type = "audio/mp3"
    #  file.status = 'queued'
    #  file.reload
    #
    #  file_info = {
    #      "input_file_path" => {"path" => input_file_name},
    #      "ext" => file_ext,
    #      "output_file_path" => {"path" => output_file_name},
    #      "output_format" => output_format,
    #      "converted_file_name" => unique_name
    #
    #  }
    #  ConvertWorker.new.perform(file_info)
    #  file.status.should == 'uploaded'
    #end

    it "Faye" do
      vars = ['name' => 'test',
              'format' => '.mp3',
              'id' => '1',
      ].to_json
      message = {:channel => "/files/new", :data => vars, :ext => {:auth_token => FAYE_TOKEN}}
      uri = URI.parse('http://127.0.0.1:9292/faye')
      p Net::HTTP.post_form(uri, :message => message.to_json)

      array = []
      Thread.new { EM.run } unless EM.reactor_running?
      Thread.pass until EM.reactor_running?


      result = Net::HTTP.get(URI.parse('http://127.0.0.1:9292/faye'))
      p result

      client = Faye::Client.new('http://127.0.0.1:9292/faye')

      client.subscribe('/files/new') do |income_message|
        p client
        array[] = income_message.inspect
      end
      array.length.should be > 0



    end

  end
end
