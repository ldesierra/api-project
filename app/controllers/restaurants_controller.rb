class RestaurantsController < ApplicationController
  respond_to :json

  def new; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.owner.skip_confirmation_notification!

    if @restaurant.save
      render json: { message: 'Restaurant solicited correctly' }, status: :ok
    else
      render json: { message: @restaurant.errors.full_messages, restaurant: @restaurant },
             status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, owner_attributes: [:email])
  end
end
