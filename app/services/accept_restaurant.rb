class AcceptRestaurant < SolidService::Base
  def call
    load_resources
    @restaurant.update(status: :incomplete)
    @manager.invite!

    if service_success
      success!(restaurant: @restaurant)
    else
      fail!(restaurant: @restaurant)
    end
  end

  private

  def load_resources
    @restaurant = params[:restaurant]
    @manager = params[:manager]
  end

  def service_success
    @restaurant.incomplete? && @manager.invited_to_sign_up?
  end
end
