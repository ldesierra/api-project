FactoryBot.define do
  factory :purchase do
    code { Random.hex.first(6) }
    status { 1 }
    qualification { 0 }
    customer
    restaurant

    after(:create) do |purchase|
      purchase.purchase_packs << create(
        :purchase_pack,
        purchase: purchase,
        pack: create(:pack, restaurant: purchase.restaurant)
      )
    end
  end
end
