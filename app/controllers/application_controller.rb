class ApplicationController < ActionController::Base
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:username, :phone, :first_name, :last_name, :avatar])
  end
end
