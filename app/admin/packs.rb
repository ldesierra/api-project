ActiveAdmin.register Pack do
  permit_params :name, :stock, :full_description, :short_description, :price, :restaurant_id,
                category_ids: []

  filter :name
  filter :stock
  filter :full_description
  filter :short_description
  filter :price
  filter :restaurant
  filter :categories

  index do
    selectable_column
    id_column
    column :name
    column :stock
    column :full_description
    column :short_description
    column :price
    column :restaurant
    actions
  end

  show do
    attributes_table do
      row :name
      row :stock
      row :full_description
      row :short_description
      row :price
      row :restaurant
      row :category_ids
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :stock
      f.input :full_description
      f.input :short_description
      f.input :price
      f.input :restaurant
      f.input :categories, multiple: true, as: :check_boxes, collection: Category.order(:name)
    end
    f.actions
  end
end
