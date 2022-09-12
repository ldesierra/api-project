class CustomerRegistrationsController < Devise::RegistrationsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { message: 'Signed up successfully', user: resource }, status: 201
    else
      render json: { message: resource.errors.full_messages, user: resource },
             status: 422
    end
  end
end
