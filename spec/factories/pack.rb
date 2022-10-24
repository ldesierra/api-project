FactoryBot.define do
  factory :pack do
    name { Faker::Name.name }
    stock { Faker::Number.between(from: 1, to: 10) }
    full_description { Faker::Hipster.sentences.sample }
    short_description { Faker::Hipster.sentences.sample }
    price { Faker::Number.between(from: 1, to: 10_000) }
    restaurant
  end
end
