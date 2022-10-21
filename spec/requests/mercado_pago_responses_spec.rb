require 'rails_helper'

RSpec.describe 'Mercado Pago responses', type: :request do
  context 'as logged customer' do
    it 'Successfull Purchase' do
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

      get '/payments/success', params: {
        external_reference: json[:purchase_id],
        status: 'approved'
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('Compra realizada')
      expect(json[:purchase_id]).to eq(customer.purchases.first.id)
    end

    it 'Wrong Purchase' do
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

      get '/payments/success', params: {
        external_reference: json[:purchase_id],
        status: 'failure'
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:error]).to eq('Problema con la compra')
    end
  end
end
