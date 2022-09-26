class RestaurantsController < ApplicationController
  respond_to :json

  include Pagy::Backend
  after_action { pagy_headers_merge(@pagy) if @pagy }

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  def new; end

  def show; end

  def index
    page, items, clients_latitude, clients_longitude = params_for_index_action

    @restaurants = @restaurants.near([clients_latitude, clients_longitude], 10_000)

    begin
      @pagy, @restaurants = pagy(@restaurants, page: page, items: items)
    rescue Pagy::OverflowError
      @restaurants = @pagy
    end

    respond_to do |format|
      format.json
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: { message: 'Restaurant solicited correctly' }, status: :ok
    else
      render json: { message: @restaurant.errors.full_messages, restaurant: @restaurant },
             status: :unprocessable_entity
    end
  end

  private

  def params_for_index_action
    items = params[:items].presence || Pagy::DEFAULT[:items]
    page = params[:page].presence || Pagy::DEFAULT[:page]

    clients_latitude = params[:latitude].presence.to_f
    clients_longitude = params[:longitude].presence.to_f

    [page, items, clients_latitude, clients_longitude]
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :phone_number, :latitude, :longitude,
                                       restaurant_users_attributes: [:name, :email, :phone_number])
  end
end
