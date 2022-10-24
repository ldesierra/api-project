module Restaurants
  class PacksController < ApplicationController
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

      @packs = Restaurant.find(restaurant_id).packs
      page = params[:page].presence
      items = params[:items].presence

      begin
        @pagy, @packs = pagy(@packs, page: page, items: items)
      rescue Pagy::OverflowError
        @packs = @pagy
      end
    end

    def create
      restaurant_id = params[:restaurant_id]

      render json: { message: 'No autorizado' }, status: 401 unless
        user_belongs_to_restaurant(restaurant_id)

      new_pack = Pack.new(pack_params.merge(restaurant_id: restaurant_id))

      if new_pack.save
        render json: { message: 'Pack creado correctamente' }, status: 201
      else
        render json: { message: new_pack.errors.full_messages }, status: 422
      end
    end

    def update
      restaurant_id = params[:restaurant_id]

      render json: { message: 'No autorizado' }, status: 401 unless
        user_belongs_to_restaurant(restaurant_id)

      if @pack.update(pack_params)
        render json: { message: 'Pack actualizado correctamente' }, status: 200
      else
        render json: { message: @pack.errors.full_messages }, status: 422
      end
    end

    private

    def user_belongs_to_restaurant(restaurant_id)
      return false if current_restaurant_user.blank?

      current_restaurant_user.restaurant_id == restaurant_id.to_i
    end

    def pack_params
      params.require(:pack).permit(:name, :price, :full_description, :short_description, :stock,
                                   category_ids: [],
                                   pictures_attributes: [:id, :image, :_destroy])
    end
  end
end
