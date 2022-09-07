class RejectRestaurant < SolidService::Base
  def call
    load_resources
    soft_delete_records

    RestaurantMailer.with(mailer_params).reject_restaurant.deliver_now

    if @restaurant.deleted? && @owner.deleted?
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

  def soft_delete_records
    @restaurant.destroy
    @owner.destroy
  end

  def mailer_params
    {
      restaurant: @restaurant,
      owner_email: @owner.email,
      reject_reason: params[:reject_reason]
    }
  end
end
