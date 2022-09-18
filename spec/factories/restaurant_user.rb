FactoryBot.define do
  factory :restaurant_user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    phone_number { '+59899999999' }
    password { Faker::Internet.password(min_length: 8) }
    restaurant
  end
end
