class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { message: 'Signed up successfuly', user: resource }, status: :created
    else
      render json: { message: resource.errors.full_messages, user: resource },
             status: :unprocessable_entity
    end
  end
end
