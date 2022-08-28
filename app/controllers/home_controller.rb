class HomeController < ApplicationController
  def index
    render json: { message: 'Hello World From NoLoTires' }, status: :ok
  end
end
