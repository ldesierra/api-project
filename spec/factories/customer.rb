FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    phone { '+59899999999' }
    password { Faker::Internet.password }
  end
end
