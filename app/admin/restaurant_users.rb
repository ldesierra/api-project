ActiveAdmin.register RestaurantUser do
  permit_params :email, :password, :name, :role, :phone_number, :restaurant_id

  filter :email
  filter :name
  filter :role, as: :select
  filter :restaurant_id

  index do
    id_column
    column :email
    column :name
    column :role
    column :phone_number
    column :restaurant_id
    actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :role
      row :phone_number
      row :restaurant_id
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
      f.input :restaurant_id, as: :select,
                              collection: Restaurant.all.map { |u| [u.name, u.id] },
                              include_blank: false
    end
    f.actions
  end
end
