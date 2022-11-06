json.cart do
  json.id @cart.id
  json.customer_id @cart.customer_id
  json.restaurant_id @cart.restaurant_id
  json.total @cart.total
  json.packs @cart.cart_packs do |cart_pack|
    json.id cart_pack.id
    json.quantity cart_pack.quantity
    json.pack do
      json.id cart_pack.pack.id
      json.price cart_pack.pack.price
      json.name cart_pack.pack.name
      json.image cart_pack.pack.pictures&.first&.image&.medium&.url
    end
  end
end
