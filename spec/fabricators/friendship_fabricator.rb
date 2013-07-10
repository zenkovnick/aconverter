Fabricator(:friendship) do
  user {Fabricate(:user)}
  friend {Fabricate(:user)}
  is_active {false}
end