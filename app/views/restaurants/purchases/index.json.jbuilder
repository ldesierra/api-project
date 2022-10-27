json.purchases @purchases do |purchase|
  json.id purchase.id
  json.customer_id purchase.customer_id
  json.customer_first_name purchase.customer.first_name
  json.customer_last_name purchase.customer.last_name
  json.status purchase.status
  json.total purchase.total
  json.restaurant_id purchase.restaurant_id
  json.qualification purchase.qualification
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
