class CustomerSessionsController < Devise::SessionsController
  respond_to :json

  protect_from_forgery with: :null_session

  skip_before_action :verify_signed_out_user
  skip_before_action :verify_authenticity_token
  after_action :skip_session

  def skip_session
    request.session_options[:skip] = true
  end

  def destroy
    customer = warden.authenticate!({ scope: :customer })

    if customer && sign_out
      respond_to_on_destroy
    else
      render json: { message: 'Error signing out' }, status: 401
    end
  end

  private

  def respond_with(_resource, _opts = {})
    render json: { message: 'Logged in successfully' }, status: 200 if current_customer.present?
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfully' }, status: 200
  end
end
