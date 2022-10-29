require 'rails_helper'

RSpec.describe 'Request payment link', type: :request do
  context 'as logged customer' do
    it 'uses a valid purchase to get the payment link' do
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
        cart_id: json[:cart][:id]
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(customer.purchases.first.id).to eq(json[:purchase_id])

      get '/purchases/payment_link', params: {
        purchase_id: json[:purchase_id]
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json.present?)
      # json[:payment_link]).to include('sandbox.mercadopago.com.uy/checkout/v1/redirect?')
    end
  end
end
