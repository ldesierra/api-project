ActiveAdmin.register Restaurant do
  permit_params :name, :owner_id, :description, :active

  action_item :pending_restaurants, only: :index do
    link_to 'Solicitudes de restaurantes', pending_restaurants_admin_restaurants_path
  end

  collection_action :pending_restaurants, method: [:get, :post] do
    @restaurants = Restaurant.inactive
  end

  action_item :accept_restaurant, only: :show do
    unless resource.active?
      link_to 'Aceptar Restaurante', accept_restaurant_admin_restaurant_path(resource.id),
              method: :patch
    end
  end

  action_item :reject_restaurant, only: :show do
    unless resource.active?
      link_to 'Rechazar Restaurante', reject_restaurant_form_admin_restaurant_path(resource.id)
    end
  end

  member_action :accept_restaurant, method: :patch do
    result = AcceptRestaurant.call(restaurant: resource, owner: resource.owner)

    if result.success?
      redirect_to pending_restaurants_admin_restaurants_path, notice: 'Restaurante aceptado'
    else
      render :pending_restaurants, notice: 'Algo salio mal'
    end
  end

  member_action :reject_restaurant_form, method: :get do
  end

  member_action :reject_restaurant, method: :post do
    result = RejectRestaurant.call(restaurant: resource, owner: resource.owner,
                                   reject_reason: params[:reject_reason])

    @restaurants = Restaurant.inactive

    if result.success?
      redirect_to pending_restaurants_admin_restaurants_path, notice: 'Restaurante rechazado'
    else
      render :pending_restaurants, notice: 'Algo salio mal'
    end
  end
end
