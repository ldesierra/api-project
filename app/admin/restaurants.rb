ActiveAdmin.register Restaurant do
  permit_params :name, :description, :status, :location, :phone_number,
                restaurant_users_attributes: [:id, :email, :name, :phone_number, :_destroy],
                open_hours_attributes: [:id, :start_time, :end_time, :day, :_destroy]

  filter :name
  filter :phone_number
  filter :location
  filter :status

  action_item :pending_restaurants, only: :index do
    link_to 'Solicitudes de restaurantes', pending_restaurants_admin_restaurants_path
  end

  collection_action :pending_restaurants do
    @restaurants = Restaurant.pending
  end

  action_item :accept_restaurant, only: :show do
    if resource.pending?
      link_to 'Aceptar Restaurante', accept_restaurant_admin_restaurant_path(resource.id),
              method: :patch
    end
  end

  action_item :reject_restaurant, only: :show do
    if resource.pending?
      link_to 'Rechazar Restaurante', reject_restaurant_form_admin_restaurant_path(resource.id)
    end
  end

  member_action :accept_restaurant, method: :patch do
    result = AcceptRestaurant.call(restaurant: resource, manager: resource.restaurant_users.first)

    if result.success?
      redirect_to pending_restaurants_admin_restaurants_path, notice: 'Restaurante aceptado'
    else
      render :pending_restaurants, notice: 'Algo salio mal'
    end
  end

  member_action :reject_restaurant_form, method: :get do
  end

  member_action :reject_restaurant, method: :post do
    result = RejectRestaurant.call(restaurant: resource, manager: resource.restaurant_users.first,
                                   reject_reason: params[:reject_reason])

    if result.success?
      redirect_to pending_restaurants_admin_restaurants_path, notice: 'Restaurante rechazado'
    else
      render :pending_restaurants, notice: 'Algo salio mal'
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :status
      row :location
      row :phone_number
      panel 'restaurant users' do
        table_for restaurant.restaurant_users do
          column :name
          column :email
          column :role
        end
      end

      panel 'open hours' do
        table_for restaurant.open_hours do
          column :day
          column :start_time
          column :end_time
        end
      end
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :description
      f.input :status
      f.input :location
      f.input :phone_number
      f.has_many :restaurant_users, allow_destroy: true do |user|
        user.input :name
        user.input :email
        user.input :phone_number
      end

      f.has_many :open_hours, allow_destroy: true do |hour|
        hour.input :day
        hour.input :start_time
        hour.input :end_time
      end
    end
    f.actions
  end
end
