json.pack do
  json.id @pack.id
  json.name @pack.name
  json.stock @pack.stock
  json.short_description @pack.short_description
  json.full_description @pack.full_description
  json.price @pack.price
  json.restaurant_id @pack.restaurant_id
  json.categories @pack.categories do |category|
    json.id category.id
    json.name category.name
  end

  json.pictures @pack.pictures do |picture|
    json.id picture.id
    json.image picture.image&.medium&.url
  end
end
