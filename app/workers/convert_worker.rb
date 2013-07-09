class ConvertWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform file_info
    input_file_path = file_info["input_file_path"]
    ext = file_info["ext"]
    output_file_path = file_info["output_file_path"]
    output_format = file_info["output_format"]
    converted_file_name = file_info["converted_file_name"]
    puts "Input file path #{input_file_path}"
    puts "Output file path #{output_file_path}"
    system "avconv -i #{input_file_path["path"]}#{ext} -ac 1 -ab 64k #{output_file_path["path"]}#{output_format}"
    #if File.file?(output_file_path["path"]+output_format)
      puts "File #{output_file_path["path"]+output_format} exists"
      file = UserFile.where(:file_name => converted_file_name).first
      p file
      if file.present?
        puts "UserFile #{converted_file_name+output_format} exists"
        vars = ['name' => file.name,
                'format' => file.output_format,
                'id' => file.id,
               ].to_json
        puts 'Updating file status'
        file.status = 'uploaded'
        file.save
        puts 'Preparing connection to Faye server'
        message = {:channel => "/files/new", :data => vars, :ext => {:auth_token => FAYE_TOKEN}}
        uri = URI.parse('http://127.0.0.1:9292/faye')
        p Net::HTTP.post_form(uri, :message => message.to_json)
      end
    #end
    File.delete(input_file_path["path"]+ext)
    puts 'Job complete'

  end
end