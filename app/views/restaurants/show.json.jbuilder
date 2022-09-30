json.restaurant do
  json.id @restaurant.id
  json.name @restaurant.name
  json.description @restaurant.description
  json.phone_number @restaurant.phone_number
  json.address @restaurant.address
  json.latitude @restaurant.latitude
  json.longitude @restaurant.longitude
  json.status @restaurant.status
  json.logo @restaurant.logo
  json.open_hours @restaurant.open_hours
  json.packs @restaurant.packs do |pack|
    json.id pack.id
    json.name pack.name
    json.stock pack.stock
    json.short_description pack.short_description
    json.full_description pack.full_description
    json.price pack.price
    json.restaurant_id pack.restaurant_id
    json.picture pack.pictures&.first&.image&.medium&.url
  end
end
