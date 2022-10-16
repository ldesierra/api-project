class CartsController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  def show
    restaurant_id = params[:restaurant_id]

    return render json: { message: 'cart no encontrado' }, status: 404 unless
      restaurant_id.present?

    user_cart

    cart_restaurant = @cart.restaurant

    @cart.clean_cart_packs if cart_restaurant.present? && cart_restaurant.id != restaurant_id

    @cart.restaurant = Restaurant.find(restaurant_id)

    @cart.save!
  end

  def add
    pack = Pack.find(params[:pack_id])
    quantity = params[:quantity]

    user_cart

    if @cart.pack?(pack)
      add_units_to_pack(pack, quantity)
    else
      add_new_pack(pack, quantity)
    end

    render json: { message: 'Pack agregado correctamente' }, status: 200
  end

  private

  def add_units_to_pack(pack, quantity)
    cart_pack = @cart.cart_packs.where(pack_id: pack.id).first
    cart_pack.quantity = cart_pack.quantity + quantity
    cart_pack.save!
  end

  def add_new_pack(pack, quantity)
    cart_pack = CartPack.create(pack_id: pack.id, quantity: quantity, cart_id: @cart.id)
    @cart.cart_packs << cart_pack
  end

  def user_cart
    session_cart_id = session[:cart_id]

    @cart = if current_customer.present? && current_customer.cart.present?
              current_customer.cart
            elsif session_cart_id.present?
              Cart.find(session_cart_id)
            else
              cart = Cart.create
              session[:cart_id] = cart.id

              cart
            end
  end
end
