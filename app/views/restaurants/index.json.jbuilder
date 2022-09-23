json.restaurants @restaurants do |restaurant|
  json.id restaurant.id
  json.name restaurant.name
  json.description restaurant.description
  json.phone_number restaurant.phone_number
  json.location restaurant.location
  json.status restaurant.status
  json.logo restaurant.logo
  json.open_hours restaurant.open_hours
end
