json.purchases @purchases do |purchase|
  json.id purchase.id
  json.customer_id purchase.customer_id
  json.purchase_packs purchase.purchase_packs do |purchase_pack|
    json.pack_id purchase_pack.pack_id
    json.quantity purchase_pack.quantity
  end
end

json.page @pagy.page
json.total_pages @pagy.pages
