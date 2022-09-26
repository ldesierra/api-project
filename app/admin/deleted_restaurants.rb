ActiveAdmin.register Restaurant, as: 'Deleted Restaurants' do
  menu parent: I18n.t('activerecord.models.restaurant.other'),
       priority: 2, url: -> { admin_deleted_restaurants_url(locale: I18n.locale) }

  controller { actions :show, :index, :destroy }
  scope :only_deleted, default: true

  after_destroy(&:really_destroy!)

  controller do
    def scoped_collection
      Restaurant.only_deleted
    end
  end

  action_item :restore, only: :show do
    link_to 'Restore Restaurante', restore_admin_deleted_restaurant_path(resource.id),
            method: :post
  end

  member_action :restore, method: :post do
    if resource.restore(recursive: true)
      redirect_to admin_deleted_restaurants_path, notice: 'Restaurante restaurado'
    else
      redirect_to admin_deleted_restaurants_path, notice: 'Algo salio mal'
    end
  end

  filter :name
  filter :phone_number
  filter :status

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :status
    column :logo
    column :phone_number
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :status
      row :address
      row :phone_number
      panel 'Restaurant users' do
        table_for resource.restaurant_users.only_deleted do
          column :name
          column :email
          column :role
        end
      end

      panel 'Open hours' do
        table_for resource.open_hours do
          column :day
          column :start_time
          column :end_time
        end
      end

      panel 'Packs' do
        table_for resource.packs do
          column :name
          column :stock
          column :description
          column :price
        end
      end
    end
  end
end
