Fabricator(:user_file) do
  name { 'Test' }
  user { Fabricate(:user) }
  output_format { '.mp3' }
  status { 'queued' }
end