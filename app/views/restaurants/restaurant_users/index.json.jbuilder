json.users @users do |user|
  json.id user.id
  json.name user.name
  json.role user.role
  json.email user.email
  json.phone_number user.phone_number
end

json.page @pagy&.page
json.total_pages @pagy&.pages
