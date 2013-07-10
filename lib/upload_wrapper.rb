class UploadWrapper
  def before_save(record)
    if record.new_record?
      file_ext = File.extname(record.name)
      file_name = File.basename(record.name, file_ext)
      unique_name = SecureRandom.uuid
      output_format = APP_CONFIG['audio_output_format']
      input_file_name = Rails.root.join('public', 'uploads', file_name)
      output_file_name = Rails.root.join('public', 'uploads', unique_name)

      record.name = file_name
      record.file_name = unique_name
      record.input_format = file_ext
      record.output_format = output_format

      file_info = {
          :input_file_path => input_file_name,
          :ext => file_ext,
          :output_file_path => output_file_name,
          :output_format => output_format,
          :converted_file_name => unique_name

      }
      puts 'Start worker'
      ConvertWorker::perform_async(file_info)
      #session[:status] = 'uploading'
    end
  end
end
