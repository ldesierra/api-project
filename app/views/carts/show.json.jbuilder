json.cart do
  json.id @cart.id
  json.customer_id @cart.customer_id
  json.total @cart.total
  json.packs @cart.cart_packs do |cart_pack|
    json.id cart_pack.id
    json.quantity cart_pack.quantity
    json.pack_id cart_pack.pack.id
  end
end
