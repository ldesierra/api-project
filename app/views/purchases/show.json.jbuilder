json.purchase do
  json.id @purchase.id
  json.total @purchase.total
  json.customer_id @purchase.customer_id
  json.status @purchase.status
  json.qualification @purchase.qualification
  json.code @purchase.code
  json.packs @purchase.purchase_packs do |purchase_pack|
    json.id purchase_pack.id
    json.quantity purchase_pack.quantity
    json.pack purchase_pack.pack.name
  end
end
