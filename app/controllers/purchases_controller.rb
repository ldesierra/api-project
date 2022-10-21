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
    cart = Cart.find(cart_params[:cart_id])

    render json: { message: 'Necesita loguearse' }, status: 401 unless cart.customer.present?

    purchase = Purchase.create(customer: cart.customer, restaurant: cart.restaurant)

    unless purchase.valid? && cart.cart_packs.any?
      return render json: { error: 'Compra invalida' },
                    status: 500
    end

    load_purchase_products_to_purchase(cart, purchase)
    clean_cart(cart)

    if purchase.valid? && cart.cart_packs.empty?
      render json: { purchase_id: purchase.id }, status: 200
    else
      render json: { error: 'No se pudo crear la compra' }, status: 500
    end
  end

  def payment_link
    purchase = Purchase.find(params[:purchase_id])

    if purchase.blank? && !purchase.waiting_for_payment?
      return render json: { error: 'Compra invalida' }, status: 500
    end

    result = PaymentLink.call(purchase: purchase)

    if result.success?
      render json: { payment_link: result.payment_link }, status: 200
    else
      render json: { error: result.error }, status: 500
    end
  end

  private

  def load_purchase_products_to_purchase(cart, purchase)
    purchase.save
    cart.cart_packs.each do |cart_pack|
      purchase.purchase_packs << PurchasePack.create(
        pack_id: cart_pack.pack_id,
        purchase_id: purchase.id,
        quantity: cart_pack.quantity
      )
    end
  end

  def clean_cart(cart)
    cart.clean_cart_packs

    cart.restaurant = nil

    cart.save
  end

  def cart_params
    params.permit(:cart_id)
  end
end
