Fabricator(:user_file) do
  name { 'Test' }
  output_format { '.mp3' }
  status {'queued'}
end