FactoryBot.define do
  factory :restaurant do
    name { Faker::Name.first_name }
    status { :pending }
  end
end
