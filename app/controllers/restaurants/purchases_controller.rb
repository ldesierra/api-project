module Restaurants
  class PurchasesController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    include Pagy::Backend
    after_action { pagy_headers_merge(@pagy) if @pagy }

    load_and_authorize_resource

    def index
      restaurant_id = params[:restaurant_id]

      if current_restaurant_user.restaurant_id != restaurant_id.to_i
        render json: { message: 'No tiene acceso a este restaurante' }, status: 401
      end

      page = params[:page] || Pagy::DEFAULT[:page]
      items = params[:items] || Pagy::DEFAULT[:items]

      @purchases = filter_purchases(@purchases)

      return unless @purchases.present?

      begin
        @pagy, @purchases = pagy(@purchases, page: page, items: items)
      rescue Pagy::OverflowError
        @purchases = @pagy
      end
    end

    def show
      restaurant_id = params[:restaurant_id]

      return unless current_restaurant_user.restaurant_id != restaurant_id.to_i

      render json: { message: 'No tiene acceso a este restaurante' }, status: 401
    end

    def delivered
      @purchase = Purchase.find_by(code: params[:code])
      @purchase.status = 'delivered'

      if @purchase.save
        render json: { message: 'Pedido marcado como entregado' }, status: 200
      else
        render json: { message: 'Error al marcar pedido como entregado' }, status: 422
      end
    end

    private

    def filter_purchases(purchases)
      purchases = purchases.where('CAST(id AS TEXT) LIKE ?', params[:id]) if params[:id].present?

      purchases = purchases.where(status: params[:status]) if params[:status].present?

      purchases
    end
  end
end
