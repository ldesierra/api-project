class AcceptRestaurant < SolidService::Base
  def call
    load_resources
    @restaurant.update(active: true)
    @owner.invite!

    RestaurantMailer.with(mailer_params).accept_restaurant.deliver_now

    if service_success
      success!(restaurant: @restaurant)
    else
      fail!(restaurant: @restaurant)
    end
  end

  private

  def load_resources
    @restaurant = params[:restaurant]
    @owner = params[:owner]
  end

  def service_success
    # onwer.valid_invitation?
    @restaurant.active? && @owner.invited_to_sign_up?
  end

  def mailer_params
    {
      restaurant: @restaurant,
      owner_email: @owner.email
    }
  end
end
