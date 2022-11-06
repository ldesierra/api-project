require 'rails_helper'

RSpec.describe 'cart show endpoint', type: :request do
  scenario 'first time requesting pack as non logged user' do
    restaurant = create(:restaurant)

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    # new cart is returned successfully
    expect(json[:cart][:id]).to_not eq(nil)
    expect(json[:cart][:restaurant_id]).to eq(restaurant.id)
  end

  context 'second time accessing cart for non logged user' do
    it 'saves the instance successfully' do
      restaurant = create(:restaurant)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      first_time_cart = Cart.find(json[:cart][:id])

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(Cart.find(json[:cart][:id])).to eq(first_time_cart)
    end
  end

  context 'changes restaurant after getting a cart' do
    it 'cart gets new restaurant id' do
      restaurant1 = create(:restaurant)
      restaurant2 = create(:restaurant)

      get '/carts', params: {
        restaurant_id: restaurant1.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:restaurant_id]).to eq(restaurant1.id)

      get '/carts', params: {
        restaurant_id: restaurant2.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:restaurant_id]).to eq(restaurant2.id)
    end
  end

  context 'requesting a cart as a logged customer' do
    it 'first time returns new pack and then returns owned cart' do
      restaurant1 = create(:restaurant)
      customer = create(:customer)

      auth = log_customer_in(customer)

      get '/carts', params: {
        restaurant_id: restaurant1.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:customer_id]).to eq(customer.id)

      cart_id = json[:cart][:id]

      get '/carts', params: {
        restaurant_id: restaurant1.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      expect(json[:cart][:id]).to eq(cart_id)
    end
  end
end
