class RestaurantsController < ApplicationController
  respond_to :json

  def new; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    restaurant_manager.skip_confirmation_notification!

    if @restaurant.save
      render json: { message: 'Restaurant solicited correctly' }, status: :ok
    else
      render json: { message: @restaurant.errors.full_messages, restaurant: @restaurant },
             status: :unprocessable_entity
    end
  end

  private

  def restaurant_manager
    @restaurant.restaurant_users.first
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :phone_number, :location,
                                       restaurant_users_attributes: [:name, :email, :phone_number])
  end
end
