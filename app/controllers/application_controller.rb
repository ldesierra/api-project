class ApplicationController < ActionController::Base
  include ::ActionController::Cookies

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:username, :phone, :first_name, :last_name, :avatar])
  end

  def current_ability
    current_user = current_customer || current_restaurant_user
    @current_ability ||= Ability.new(current_user)
  end
end
