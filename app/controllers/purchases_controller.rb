class PurchasesController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  include Pagy::Backend
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    return render json: { message: 'No autorizado' }, status: 401 unless current_customer.present?

    page = params[:page].presence || Pagy::DEFAULT[:page]
    items = params[:items].presence || Pagy::DEFAULT[:items]

    @purchases = filter_purchases(@purchases)

    return unless @purchases.present?

    begin
      @pagy, @purchases = pagy(@purchases, page: page, items: items)
    rescue Pagy::OverflowError
      @purchases = @pagy
    end
  end

  def show
    return render json: { message: 'No autorizado' }, status: 401 unless current_customer.present?
  end

  def create
    cart = Cart.find(cart_params[:cart_id])

    return render json: { message: 'Necesita usuario' }, status: 401 unless cart.customer.present?

    if not_enough_stock_for_purchase(cart)
      return render json: { message: 'No hay suficiente stock' }, status: 422
    end

    purchase = Purchase.new(customer: cart.customer, restaurant: cart.restaurant)

    unless purchase.valid? && cart.cart_packs.any?
      return render json: { error: 'Compra invalida' },
                    status: 500
    end

    purchase.save!

    begin
      load_purchase_products_to_purchase(cart, purchase)
      clean_cart(cart)
    rescue StandardError
      return render json: { message: 'Error al crear el pedido' }, status: 401
    end

    render json: { purchase_id: purchase.id }, status: 200
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

  def not_enough_stock_for_purchase(cart)
    cart.cart_packs.each do |cart_pack|
      return true if cart_pack.quantity > cart_pack.stock
    end

    false
  end

  def filter_purchases(purchases)
    if params[:id].present?
      purchases = purchases.where('CAST(id AS TEXT) LIKE ?',
                                  "%#{params[:id]}%")
    end

    purchases = purchases.where(status: params[:status]) if params[:status].present?

    purchases
  end

  def load_purchase_products_to_purchase(cart, purchase)
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
