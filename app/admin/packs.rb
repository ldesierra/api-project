ActiveAdmin.register Pack do
  permit_params :name, :stock, :description, :price, :restaurant_id,
                category_ids: []

  filter :name
  filter :stock
  filter :description
  filter :price
  filter :restaurant
  filter :categories

  index do
    selectable_column
    id_column
    column :name
    column :stock
    column :description
    column :price
    column :restaurant
    column :categories
    actions
  end

  show do
    attributes_table do
      row :name
      row :stock
      row :description
      row :price
      row :restaurant
      row :categories
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :stock
      f.input :description
      f.input :price
      f.input :restaurant
    end
    f.inputs 'Categories' do
      f.input :categories, as: :check_boxes, collection: Category.all
    end
    f.actions
  end
end
