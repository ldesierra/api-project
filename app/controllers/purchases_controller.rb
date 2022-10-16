class PurchasesController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  include Pagy::Backend
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    page = params[:page].presence || Pagy::DEFAULT[:page]
    items = params[:items].presence || Pagy::DEFAULT[:items]

    begin
      @pagy, @purchases = pagy(@purchases, page: page, items: items)
    rescue Pagy::OverflowError
      @purchases = @pagy
    end
  end

  def show; end

  def create
    cart = Cart.find(params[:cart_id])

    render json: { message: 'Necesita loguearse' }, status: 401 unless cart.customer.present?

    purchase = Purchase.create(customer: cart.customer, restaurant: cart.restaurant)

    cart.cart_packs.each do |cart_pack|
      purchase.purchase_packs << PurchasePack.create(
        pack_id: cart_pack.pack_id,
        purchase_id: purchase.id,
        quantity: cart_pack.quantity
      )
    end

    clean_cart(cart)
  end

  private

  def clean_cart(cart)
    cart.clean_cart_packs

    cart.restaurant = nil

    cart.save
  end

  def purchase_params
    params.permit(:cart_id)
  end
end
