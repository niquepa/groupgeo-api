Fabricator(:user) do
  email { Faker::Internet.free_email }
  password { Faker::Internet.password(8) }
end