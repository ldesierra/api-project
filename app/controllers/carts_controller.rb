class CartsController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  def show
    restaurant_id = params[:restaurant_id]

    return render json: { message: 'No puede haber cart sin restaurante' }, status: 404 unless
      restaurant_id.present?

    user_cart

    cart_restaurant = @cart.restaurant

    @cart.clean_cart_packs if cart_restaurant.present? && cart_restaurant.id != restaurant_id.to_i

    @cart.restaurant = Restaurant.find(restaurant_id)

    @cart.save!
  end

  def add
    restaurant_id = params[:restaurant_id]

    return render json: { message: 'No puede haber cart sin restaurante' }, status: 404 unless
      restaurant_id.present?

    pack = Pack.find(params[:pack_id])
    quantity = params[:quantity]

    user_cart

    if @cart.restaurant_id != restaurant_id.to_i
      @cart.clean_cart_packs
      @cart.update_column(:restaurant_id, params[:restaurant_id])
    end

    add_units_to_pack(pack, quantity)

    if @error.present?
      render json: { message: @error }, status: 422
    else
      render json: { message: 'Pack agregado correctamente', cart: @cart.reload }, status: 200
    end
  end

  def remove
    restaurant_id = params[:restaurant_id]

    return render json: { message: 'No puede haber cart sin restaurante' }, status: 404 unless
      restaurant_id.present?

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
    if @cart.pack?(pack)
      cart_pack = @cart.cart_packs.where(pack_id: pack.id).first
      quantity = cart_pack.quantity + quantity.to_i
    end

    if quantity.to_i > pack.stock
      @error = 'No hay stock'
    elsif @cart.pack?(pack)
      cart_pack.quantity = quantity
      cart_pack.save!
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
