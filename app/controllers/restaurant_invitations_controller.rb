class RestaurantInvitationsController < Devise::InvitationsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  prepend_before_action :require_no_authentication, only: [:edit, :update, :destroy]

  # PUT /resource/invitation
  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    load_restaurant_user

    if @restaurant_user.restaurant.active?
      self.resource = accept_resource
      invitation_accepted = resource.errors.empty?

      yield resource if block_given?

      if invitation_accepted
        if resource.class.allow_insecure_sign_in_after_accept
          resource.after_database_authentication
          sign_in(resource_name, resource)
        end

        render json: { message: 'Invitation accepted successfully' }, status: 200
      else
        resource.invitation_token = raw_invitation_token
        render json: { message: resource.errors.full_messages }, status: 422
      end
    else
      update_restaurant

      if @restaurant.valid?
        self.resource = accept_resource
        invitation_accepted = resource.errors.empty?

        if invitation_accepted
          @restaurant.save

          if resource.class.allow_insecure_sign_in_after_accept
            resource.after_database_authentication
            sign_in(resource_name, resource)

          end
          render json: { message: 'Invitation accepted successfully' }, status: 200
        else
          resource.invitation_token = raw_invitation_token
          render json: { message: resource.errors.full_messages }, status: 422
        end
      else
        render json: { message: resource.errors.full_messages }, status: 422
      end
    end
  end

  private

  def load_restaurant_user
    @restaurant_user = RestaurantUser.find(params[:id])
  end

  def update_restaurant
    @restaurant = Restaurant.find(resource.restaurant_id)
    @restaurant.update(restaurant_params)
  end

  def restaurant_params
    params.require(:restaurant).permit(:id, :name, :description, :status, :logo,
                                       open_hours_attributes: [:start_time, :end_time, :day])
  end
end
