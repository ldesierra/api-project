class RestaurantRegistrationsController < Devise::RegistrationsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { message: 'Signed up successfuly', restaurant_user: resource }, status: :created
    else
      render json: { message: resource.errors.full_messages, restaurant_user: resource },
             status: :unprocessable_entity
    end
  end
end
