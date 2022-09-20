FactoryBot.define do
  factory :restaurant do
    name { Faker::Name.first_name }
    status { :pending }
    phone_number { '+59899999999' }

    before(:create) do |restaurant|
      restaurant.restaurant_users << create(:restaurant_user, restaurant: restaurant)
    end
  end
end
