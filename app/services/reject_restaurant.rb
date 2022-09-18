class RejectRestaurant < SolidService::Base
  def call
    load_resources
    soft_delete_records

    RestaurantMailer.with(mailer_params).reject_restaurant.deliver_now

    if @restaurant.deleted? && @manager.deleted?
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

  def soft_delete_records
    @restaurant.destroy
    @manager.destroy
  end

  def mailer_params
    {
      restaurant: @restaurant,
      manager_email: @manager.email,
      reject_reason: params[:reject_reason]
    }
  end
end
