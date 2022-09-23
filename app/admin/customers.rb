ActiveAdmin.register Customer do
  permit_params :email, :password, :first_name, :last_name, :phone, :username, :avatar

  filter :email
  filter :first_name
  filter :last_name
  filter :username

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone
    column :username
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :phone
      row :username
      row :avatar do |customer|
        if customer.avatar?
          image_tag(customer.avatar.url(:thumb), height: 100)
        else
          content_tag(:span, I18n.t('admin.customers.no_avatar'))
        end
      end
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :email
      f.input :password
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :username
      f.input :avatar, hint: f.object[:avatar]
    end
    f.actions
  end
end
