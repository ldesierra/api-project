json.packs @packs do |pack|
  json.id pack.id
  json.name pack.name
  json.stock pack.stock
  json.full_description pack.full_description
  json.short_description pack.short_description
  json.price pack.price
  json.categories pack.categories.uniq do |category|
    json.name category.name
    json.id category.id
  end
end

json.page @pagy.page
json.total_pages @pagy.pages
