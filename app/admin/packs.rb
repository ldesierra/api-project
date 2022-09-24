ActiveAdmin.register Pack do
  permit_params :name, :stock, :full_description, :short_description, :price, :restaurant_id,
                category_ids: [],
                pictures_attributes: [:id, :imageable_id, :imageable_type, :image, :_destroy]

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
      panel 'Imágenes' do
        table_for pack.pictures do |_p|
          column :image do |c|
            image_tag c.image.try(:thumb).try(:url)
          end
        end
      end
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
      f.has_many :pictures, heading: 'Imágenes' do |p|
        p.input :image, as: :file, label: 'Imagen', hint: (
          unless p.object.blank? || p.object.image.blank?
            p.template.image_tag(p.object.image.try(:thumb).try(:url))
          end)

        p.input :_destroy, as: :boolean, required: false, label: 'Remover imagen'
      end
    end
    f.actions
  end
end
