ActiveAdmin.register RestaurantUser do
  menu parent: I18n.t('activerecord.models.restaurant_user.other'),
       priority: 1, url: -> { admin_restaurant_users_url(locale: I18n.locale) }

  before_create(&:confirm)

  permit_params :email, :password, :name, :role, :phone_number, :restaurant_id

  filter :email
  filter :name
  filter :role, as: :select, collection: RestaurantUser.roles
  filter :restaurant

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :phone_number
    column :restaurant
    actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :role
      row :phone_number
      row :restaurant
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :email
      f.input :password
      f.input :name
      f.input :role
      f.input :phone_number
      f.input :restaurant
    end
    f.actions
  end
end
