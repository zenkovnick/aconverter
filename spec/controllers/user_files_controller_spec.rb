require 'spec_helper'
#require 'controller_spec_helper'
require 'eventmachine'
require 'faye'

Spec::Matchers.define :exist_in_database do

  match do |actual|
    actual.class.exists?(actual.id)
  end

end


describe UserFilesController do
  #fixtures :users, :user_files
  before(:each) do
    @user = Fabricate(:user)
    @file = Fabricate(:user_file)
    sign_in @user
  end

  def file_attachment
    test_document = "#{Rails.root}/spec/assets/attachments/Example.ogg"
    Rack::Test::UploadedFile.new(test_document, "audio/ogg")
  end

  describe "POST to #create" do
    before do
      post :create, :user_file => {:name =>
                                     fixture_file_upload("/test.mp3", "audio/mp3") }
    end
    it "Upload" do
      expect(response).to redirect_to(@user)
    end
  end


  describe "Worker" do
    it "Convert" do
      post :create, :user_file => {:name =>
                                       fixture_file_upload("/test.mp3", "audio/mp3") }
      file_ext = '.mp3'
      file_name = 'test'
      unique_name = SecureRandom.uuid
      output_format = APP_CONFIG['audio_output_format']
      input_file_name = Rails.root.join('public', 'uploads', file_name).to_s
      output_file_name = Rails.root.join('public', 'uploads', unique_name).to_s

      @file.file_name = unique_name
      @file.input_format = file_ext
      @file.output_format = output_format
      @file.user = @user
      @file.content_type = "audio/mp3"
      @file.status = 'queued'
      @file.save

      file_info = {
          "input_file_path" => {"path" => input_file_name},
          "ext" => file_ext,
          "output_file_path" => {"path" => output_file_name},
          "output_format" => output_format,
          "converted_file_name" => unique_name

      }
      ConvertWorker.new.perform(file_info)
      @file.reload
      @file.status.should == 'uploaded'
    end

    it "Faye" do
      self.use_transactional_fixtures = false
      vars = ['name' => 'test',
              'format' => '.mp3',
              'id' => '1',
      ].to_json
      message_content = {:channel => '/files/new', :data => vars, :ext => {:auth_token => 'testtokenaconverter'}}


      #Thread.new { EM.run } unless EM.reactor_running?
      #Thread.pass until EM.reactor_running?
      uri = URI.parse('http://127.0.0.1:9292/faye')
      p Net::HTTP.post_form(uri, :message => message_content.to_json)

      sleep 1

      EM.run do
        array = []
        client = Faye::Client.new('http://127.0.0.1:9292/faye')

        subscription = client.subscribe('/files/new') do |data|
          puts "Message: #{data.inspect}"
          array << data
        end

        subscription.callback do
          puts "[SUBSCRIBE SUCCEEDED]"
          EM.stop
          array.length.should be > 0

        end
        subscription.errback do |error|
          puts "[SUBSCRIBE FAILED] #{error.inspect}"
        end

        client.bind 'transport:down' do
          puts "[CONNECTION DOWN]"
        end
        client.bind 'transport:up' do
          puts "[CONNECTION UP]"
        end
      end


    end

  end
end
