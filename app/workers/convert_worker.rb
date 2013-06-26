class ConvertWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  def perform input_file_name, ext, output_file_name, output_format
    #if ext == '.ogg'
      system "avconv -i #{input_file_name["path"]}#{ext} -ac 1 -ab 64k #{output_file_name["path"]}#{output_format}"
    #end
    if File.file?(output_file_name["path"]+output_format)
      File.delete(input_file_name["path"]+ext)
    end
  end
end