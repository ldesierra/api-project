FactoryBot.define do
  factory :restaurant_user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    phone_number { "+598#{Faker::Number.number(digits: 8)}" }
    password { Faker::Internet.password(min_length: 8) }
    role { :manager }
  end
end
