FactoryBot.define do
  factory :purchase_pack do
    pack
    purchase
    quantity { 1 }
  end
end
