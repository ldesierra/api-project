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

    @cart.clean_cart_packs if cart_restaurant.present? && cart_restaurant.id != restaurant_id.to_i

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

    if @error.present?
      render json: { message: @error }, status: 422
    else
      render json: { message: 'Pack agregado correctamente', cart: @cart }, status: 200
    end
  end

  def remove
    pack = Pack.find(params[:pack_id])

    user_cart

    if @cart.pack?(pack)
      remove_from_cart(pack)
      render json: { message: 'Pack borrado correctamente del carro' }, status: 200
    else
      render json: { message: 'Pack no pertenece al carro' }, status: 404
    end
  end

  private

  def remove_from_cart(pack)
    cart_pack = @cart.cart_packs.where(pack_id: pack.id).first
    cart_pack.destroy!
    @cart.cart_packs.delete(cart_pack)
  end

  def add_units_to_pack(pack, quantity)
    cart_pack = @cart.cart_packs.where(pack_id: pack.id).first
    new_quantity = cart_pack.quantity + quantity.to_i

    if new_quantity.to_i > cart_pack.stock
      @error = 'No hay stock'
    else
      cart_pack.quantity = new_quantity
      cart_pack.save!
    end
  end

  def add_new_pack(pack, quantity)
    if quantity.to_i > pack.stock
      @error = 'No hay stock'
    else
      cart_pack = CartPack.create(pack_id: pack.id, quantity: quantity, cart_id: @cart.id)
      @cart.cart_packs << cart_pack
    end
  end

  # rubocop:disable Metrics/AbcSize

  def user_cart
    session_cart_id = session[:cart_id]

    @cart = if current_customer.present? && current_customer.cart.present?
              current_customer.cart
            elsif session_cart_id.present? && Cart.find(session_cart_id).present?
              Cart.find(session_cart_id)
            else
              cart = Cart.create

              if current_customer.present?
                cart.customer_id = current_customer.id
              else
                session[:cart_id] = cart.id
              end

              cart
            end
  end

  # rubocop:enable Metrics/AbcSize
end
