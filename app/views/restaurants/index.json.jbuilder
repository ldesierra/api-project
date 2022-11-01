json.restaurants @restaurants do |restaurant|
  json.id restaurant.id
  json.name restaurant.name
  json.description restaurant.description
  json.phone_number restaurant.phone_number
  json.address restaurant.address
  json.latitude restaurant.latitude
  json.longitude restaurant.longitude
  json.status restaurant.status
  json.logo restaurant.logo
  json.qualification restaurant.qualification
  json.open_hours restaurant.open_hours
  json.categories restaurant.main_categories do |category|
    json.name category.name
    json.id category.id
  end
end

json.page @pagy&.page
json.total_pages @pagy&.pages
