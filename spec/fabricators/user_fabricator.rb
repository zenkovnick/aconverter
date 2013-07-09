Fabricator(:user) do
  username { Faker::Name.name }
  email { |attrs| "#{attrs[:username].parameterize}@example.com" }
  password {Devise.friendly_token[0..20]}
end
