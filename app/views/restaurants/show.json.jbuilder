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
  json.categories @restaurant.categories.uniq do |category|
    json.name category.name
    json.id category.id
  end

  json.packs @restaurant.packs do |pack|
    json.id pack.id
    json.name pack.name
    json.stock pack.stock
    json.short_description pack.short_description
    json.full_description pack.full_description
    json.price pack.price
    json.restaurant_id pack.restaurant_id
    json.picture pack.pictures&.first&.image&.medium&.url
    json.categories pack.categories do |category|
      json.id category.id
      json.name category.name
    end
  end
end
