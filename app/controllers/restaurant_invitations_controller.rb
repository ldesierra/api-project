class RestaurantInvitationsController < Devise::InvitationsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  prepend_before_action :require_no_authentication, only: [:edit, :update, :destroy]

  # PUT /resource/invitation
  def update
    load_restaurant_user

    unless @restaurant_user.blank? || restaurant_active
      update_restaurant

      return respond_with_restaurant_errors unless @restaurant.valid?
    end

    self.resource = accept_resource

    if resource.no_errors?
      setup_restaurant unless restaurant_active

      insecure_sign_in_if_allowed(resource_name, resource)

      render json: { message: 'Invitation accepted successfully' }, status: 200
    else
      respond_with_errors(resource)
    end
  end

  private

  def respond_with_errors(_resource)
    render json: { message: resource.full_messages_for_errors }, status: 422
  end

  def respond_with_restaurant_errors
    render json: { message: @restaurant.errors.full_messages }, status: 422
  end

  def insecure_sign_in_if_allowed(resource_name, resource)
    return unless resource.class.allow_insecure_sign_in_after_accept

    resource.after_database_authentication
    sign_in(resource_name, resource)
  end

  def restaurant_active
    @restaurant_user.restaurant.complete?
  end

  def setup_restaurant
    @restaurant.save
    @restaurant.active!
  end

  def load_restaurant_user
    @restaurant_user = RestaurantUser.find_by_invitation_token(invitation_token, true)
  end

  def update_restaurant
    return unless resource.present?

    @restaurant = Restaurant.find(resource.restaurant_id)
    @restaurant.assign_attributes(restaurant_params)
  end

  def invitation_token
    params.require(:restaurant_user)[:invitation_token]
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :logo, :phone_number, :address,
                                       open_hours_attributes: [:start_time, :end_time, :day])
  end
end
