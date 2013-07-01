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
    if File.file?(output_file_path["path"]+output_format)
      file = UserFile.where(:file_name => converted_file_name).first
      puts 'File present' if file.present?
      if file.present?
        file.status = 'uploaded'
        file.save
      end
    end
    File.delete(input_file_path["path"]+ext)
  end
end