module Restaurants
  class RestaurantUsersController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    load_and_authorize_resource

    include Pagy::Backend
    after_action { pagy_headers_merge(@pagy) if @pagy }

    def index
      restaurant_id = params[:restaurant_id]

      render json: { message: 'No autorizado' }, status: 401 unless
        user_belongs_to_restaurant(restaurant_id)

      @users = Restaurant.find(restaurant_id).restaurant_users

      page = params[:page].presence || Pagy::DEFAULT[:page]
      items = params[:items].presence || Pagy::DEFAULT[:items]

      begin
        @pagy, @packs = pagy(@users, page: page, items: items)
      rescue Pagy::OverflowError
        @packs = @pagy
      end
    end

    private

    def user_belongs_to_restaurant(restaurant_id)
      return false if current_restaurant_user.blank?

      current_restaurant_user.restaurant_id == restaurant_id.to_i
    end
  end
end
