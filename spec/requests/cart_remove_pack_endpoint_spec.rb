require 'rails_helper'

RSpec.describe 'cart remove pack endpoint', type: :request do
  scenario 'as non logged user' do
    restaurant = create(:restaurant)
    pack = create(:pack, restaurant: restaurant)

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    put '/carts/add', params: {
      quantity: 3,
      pack_id: pack.id,
      restaurant_id: restaurant.id
    }, as: :json

    put '/carts/remove', params: {
      pack_id: pack.id,
      restaurant_id: restaurant.id
    }, as: :json

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:cart][:packs]).to eq([])
  end

  context 'as logged customer' do
    it 'removes pack successfully' do
      restaurant = create(:restaurant)
      pack = create(:pack, restaurant: restaurant)
      customer = create(:customer)

      auth = log_customer_in(customer)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      put '/carts/add', params: {
        quantity: 3,
        restaurant_id: restaurant.id,
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      put '/carts/remove', params: {
        restaurant_id: restaurant.id,
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:packs]).to eq([])
    end
  end
end
