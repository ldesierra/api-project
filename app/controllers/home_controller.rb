class HomeController < ApplicationController
  before_action :authenticate_customer_or_restaurant_user

  def index
    render json: { message: 'Hello World From NoLoTires', customer: current_customer }, status: 200
  end

  private

  def authenticate_customer_or_restaurant_user
    customer = warden.authenticate?({ scope: :customer })
    restaurant_user = warden.authenticate?({ scope: :restaurant_user })

    throw(:warden, {}) unless customer || restaurant_user
  end
end
