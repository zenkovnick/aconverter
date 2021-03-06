class Utils
  def self.check_folder(dir_path)
    unless File.directory?(dir_path)
      FileUtils.mkdir_p(dir_path)
      FileUtils.chmod_R(0777, dir_path)
    end
  end

  def self.conver_file_name(file_name)
    file_name.gsub(/['"%\$\\\/() ]/, '_')
  end

  def self.check_content_type(content_type)
    ['audio/ogg', 'audio/flac', 'audio/mp3', 'audio/mpeg', 'video/ogg'].include?(content_type)
  end
end