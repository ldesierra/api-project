require 'rails_helper'

RSpec.describe 'Customer creates purchase spec', type: :request do
  context 'as logged customer' do
    it 'purchases without packs and fails' do
      restaurant = create(:restaurant)
      create(:pack, restaurant: restaurant)
      customer = create(:customer)

      auth = log_customer_in(customer)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      post '/purchases', params: {
        cart_id: Cart.find(json[:cart][:id]).id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:error]).to eq('Compra invalida')
    end

    it 'adds packs successfully and creates the purchase successfully' do
      restaurant = create(:restaurant)
      pack = create(:pack, restaurant: restaurant)
      customer = create(:customer)

      auth = log_customer_in(customer)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      put '/carts/add', params: {
        quantity: pack.stock - 1,
        pack_id: pack.id,
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      post '/purchases', params: {
        cart_id: Cart.find(json[:cart][:id]).id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(customer.purchases.first.id).to eq(json[:purchase_id])
      expect(Purchase.find(json[:purchase_id]).status).to eq('waiting_for_payment')
    end
  end
end
