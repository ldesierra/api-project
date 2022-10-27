json.purchases @purchases do |purchase|
  json.id purchase.id
  json.total purchase.total
  json.customer_id purchase.customer_id
  json.restaurant_id purchase.restaurant_id
  json.status purchase.status
  json.qualification purchase.qualification
  json.code purchase.code
  json.purchase_packs purchase.purchase_packs do |purchase_pack|
    json.pack_id purchase_pack.pack_id
    json.quantity purchase_pack.quantity
    json.pack do
      json.id purchase_pack.pack.id
      json.price purchase_pack.pack.price
      json.name purchase_pack.pack.name
      json.image purchase_pack.pack.pictures&.first&.image&.medium&.url
    end
  end
end

json.page @pagy&.page
json.total_pages @pagy&.pages
