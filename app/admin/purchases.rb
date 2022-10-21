ActiveAdmin.register Purchase do
  permit_params :status, :qualification, :code, :total, :customer_id, :restaurant_id,
                purchase_packs_attributes: [:id, :quantity, :purchase_id, :pack_id, :_destroy]

  filter :status, as: :select, collection: Purchase.statuses
  filter :qualification
  filter :code
  filter :total
  filter :customer
  filter :restaurant

  index do
    selectable_column
    id_column
    column :status
    column :qualification
    column :code
    column :total
    column :customer
    column :restaurant
    actions
  end

  show do
    attributes_table do
      row :status
      row :qualification
      row :code
      row :total
      row :customer
      row :restaurant

      panel 'Packs' do
        table_for purchase.packs do
          column :name
          column :stock
          column :full_description
          column :short_description
          column :price
          column :categories
        end
      end
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :customer
      f.input :restaurant
      f.has_many :purchase_packs,
                 heading: 'Packs',
                 new_record: 'Añadir Pack',
                 remove_record: 'Quitar',
                 allow_destroy: true do |c|
        c.input :pack, as: :select,
                       collection: Pack.all.map { |pack| [pack.pack_and_restaurant_names, pack.id] }
        c.input :quantity
      end
    end
    f.actions
  end
end
