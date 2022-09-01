class HomeController < ApplicationController
  before_action :authenticate_customer!

  def index
    render json: { message: 'Hello World From NoLoTires', customer: current_customer }, status: :ok
  end
end
