class RestaurantsController < ApplicationController
  respond_to :json

  include Pagy::Backend
  after_action { pagy_headers_merge(@pagy) if @pagy }

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  def show
    return render json: { message: 'Restaurante no encontrado' }, status: 404 if
      @restaurant.blank?
  end

  def index
    page, items, clients_latitude, clients_longitude = params_for_index_action

    @restaurants = @restaurants.near([clients_latitude, clients_longitude], 10_000)

    @restaurants = filter_restaurant(@restaurants)

    if @restaurants.present?
      begin
        @pagy, @restaurants = pagy(@restaurants, page: page, items: items)
      rescue Pagy::OverflowError
        @restaurants = @pagy
      end
    end

    respond_to do |format|
      format.json
    end
  end

  def update
    if @restaurant.update(update_params)
      render json: { message: 'Restaurante actualizado correctamente' }, status: :ok
    else
      render json: { message: 'Error al actualizar restaurante' }, status: :unprocessable_entity
    end
  end

  def create
    @restaurant = Restaurant.new(create_params)

    if @restaurant.save
      render json: { message: 'Restaurante solicitado correctamente' }, status: :ok
    else
      render json: { message: @restaurant.errors.full_messages, restaurant: @restaurant },
             status: :unprocessable_entity
    end
  end

  private

  def filter_restaurant(restaurants)
    return restaurants unless params[:category].present?

    restaurant_ids = restaurants.filter do |restaurant|
      (restaurant.main_categories.pluck(:name) & JSON[params[:category]]).present?
    end

    Restaurant.where(id: restaurant_ids)
  end

  def params_for_index_action
    items = params[:items].presence || Pagy::DEFAULT[:items]
    page = params[:page].presence || Pagy::DEFAULT[:page]

    clients_latitude = params[:latitude].presence.to_f
    clients_longitude = params[:longitude].presence.to_f

    [page, items, clients_latitude, clients_longitude]
  end

  def update_params
    params.require(:restaurant).permit(:name, :phone_number, :latitude, :longitude, :address,
                                       :description, :logo,
                                       open_hours_attributes: [:day, :start_time, :end_time,
                                                               :id, :_destroy])
  end

  def create_params
    params.require(:restaurant).permit(:name, :phone_number, :latitude, :longitude, :address,
                                       restaurant_users_attributes: [:name, :email, :phone_number])
  end
end
