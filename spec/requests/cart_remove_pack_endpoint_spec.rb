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
      pack_id: pack.id
    }, as: :json

    put '/carts/remove', params: {
      pack_id: pack.id
    }, as: :json

    sleep(1)

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:cart][:total]).to eq(0)
    expect(json[:cart][:packs]).to eq([])
  end

  context 'as logged customer' do
    it 'adds packs successfully and changes quantity if requested again' do
      restaurant = create(:restaurant)
      pack = create(:pack, restaurant: restaurant)
      customer = create(:customer)

      auth = log_customer_in(customer)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      put '/carts/add', params: {
        quantity: 3,
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      put '/carts/remove', params: {
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      sleep(1)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:total]).to eq(0)
    end
  end
end
