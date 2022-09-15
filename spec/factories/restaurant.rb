FactoryBot.define do
  factory :restaurant do
    name { Faker::Name.first_name }
    active { true }
  end
end
