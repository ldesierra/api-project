class RestaurantPasswordsController < Devise::PasswordsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  after_action :skip_session

  def skip_session
    request.session_options[:skip] = true
  end

  def create
    return respond_with_success unless RestaurantUser.exists?(email: resource_params[:email])

    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with_success
    else
      render json: { message: 'Error' }, status: 500
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      render json: { message: 'Password changed successfully' }, status: 200
    else
      render json: { message: resource.errors.full_messages, user: resource }, status: 422
    end
  end

  private

  def respond_with_success
    render json: { message: 'Follow instructions sent to your mail to reset password' },
           status: 200
  end
end
