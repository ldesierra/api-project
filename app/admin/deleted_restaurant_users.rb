ActiveAdmin.register RestaurantUser, as: 'Deleted Restaurant Users' do
  menu parent: I18n.t('activerecord.models.restaurant_user.other'),
       priority: 2, url: -> { admin_deleted_restaurant_users_url(locale: I18n.locale) }

  controller { actions :show, :index, :destroy }
  scope :only_deleted, default: true

  after_destroy(&:really_destroy!)

  controller do
    def scoped_collection
      RestaurantUser.only_deleted
    end
  end

  action_item :restore, only: :show do
    link_to 'Restore Restaurant User', restore_admin_deleted_restaurant_user_path(resource.id),
            method: :post
  end

  member_action :restore, method: :post do
    if resource.restore && !resource.deleted?
      redirect_to admin_deleted_restaurant_users_path, notice: 'Restaurant User restaurado'
    else
      redirect_to admin_deleted_restaurant_users_path,
                  alert: resource.errors.full_messages.to_sentence
    end
  end

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
    column :restaurant do |user|
      if user.restaurant.blank?
        restaurant = Restaurant.only_deleted.find(user.restaurant_id)
        link_to restaurant.name, admin_deleted_restaurant_path(restaurant)
      else
        restaurant = Restaurant.find(user.restaurant_id)
        link_to restaurant.name, admin_restaurant_path(restaurant)
      end
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :role
      row :phone_number
      row :restaurant do |user|
        if user.restaurant.blank?
          restaurant = Restaurant.only_deleted.find(user.restaurant_id)
          link_to restaurant.name, admin_deleted_restaurant_path(restaurant)
        else
          link_to user.restaurant.name, admin_restaurant_path(user.restaurant)
        end
      end
    end
  end
end
