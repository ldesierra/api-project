ActiveAdmin.register RestaurantUser do
  menu parent: I18n.t('activerecord.models.restaurant_user.other'),
       priority: 1, url: -> { admin_restaurant_users_url(locale: I18n.locale) }

  permit_params :email, :password, :name, :role, :phone_number, :restaurant_id

  filter :email
  filter :name
  filter :role, as: :select, collection: RestaurantUser.roles
  filter :restaurant

  action_item :confirm_user, only: :show do
    unless resource.confirmed?
      link_to 'Confirmar usuario', confirm_user_admin_restaurant_user_path(resource.id),
              method: :post
    end
  end

  member_action :confirm_user, method: :post do
    if resource.password.present?
      resource.confirm
      redirect_to admin_restaurant_users_path, notice: 'Confirmado'
    else
      redirect_to edit_admin_restaurant_user_path, alert: 'Configure contrasena para confirmar'
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :phone_number
    column :restaurant
    column :confirmed?
    actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :role
      row :phone_number
      row :restaurant
      row :confirmed?
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
