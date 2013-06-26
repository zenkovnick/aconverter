class UploadWrapper
  def before_save(record)
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

    ConvertWorker::perform_async(input_file_name, file_ext, output_file_name, output_format)
  end
end
