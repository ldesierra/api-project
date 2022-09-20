ActiveAdmin.register Category do
  permit_params :name

  filter :name

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
      panel 'Packs' do
        table_for category.packs do
          column :name
          column :stock
          column :description
          column :price
          column :restaurant
        end
      end
    end
  end
end
