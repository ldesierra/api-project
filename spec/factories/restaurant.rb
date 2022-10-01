FactoryBot.define do
  factory :restaurant do
    name { Faker::Name.first_name }
    status { :active }
    phone_number { '+59899999999' }
    address { Faker::Address.secondary_address }
    description { Faker::Hipster.sentences.sample }

    before(:create) do |restaurant|
      restaurant.restaurant_users << create(:restaurant_user, restaurant: restaurant)
      restaurant.open_hours << create(:open_hour, restaurant: restaurant)
    end
  end
end
