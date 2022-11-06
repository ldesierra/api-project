require 'rails_helper'

RSpec.describe 'cart add pack endpoint', type: :request do
  scenario 'as non logged user' do
    restaurant = create(:restaurant)
    pack = create(:pack, restaurant: restaurant)

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:cart][:total]).to eq(nil)
    expect(json[:cart][:packs]).to eq([])

    put '/carts/add', params: {
      quantity: pack.stock,
      restaurant_id: restaurant.id,
      pack_id: pack.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:cart][:total]).to eq(pack.price * pack.stock)
    expect(json[:message]).to eq('Pack agregado correctamente')

    get '/carts', params: {
      restaurant_id: restaurant.id
    }, as: :json

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:cart][:packs][0][:pack][:id]).to eq(pack.id)
    expect(json[:cart][:packs][0][:quantity]).to eq(pack.stock)
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
        quantity: pack.stock - 1,
        pack_id: pack.id,
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('Pack agregado correctamente')

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:packs][0][:pack][:id]).to eq(pack.id)

      put '/carts/add', params: {
        quantity: 1,
        restaurant_id: restaurant.id,
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:packs][0][:quantity]).to eq(pack.stock)
      expect(json[:cart][:total]).to eq(pack.stock * pack.price)
    end

    it 'adds packs successfully and changes quantity unsuccessfully with more packs than stock' do
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

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('Pack agregado correctamente')

      put '/carts/add', params: {
        quantity: pack.stock + 1,
        restaurant_id: restaurant.id,
        pack_id: pack.id
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('No hay stock')
    end
  end

  context 'adding more packs than stock' do
    it 'is rejected' do
      restaurant = create(:restaurant)
      pack = create(:pack, restaurant: restaurant)

      get '/carts', params: {
        restaurant_id: restaurant.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:cart][:total]).to eq(nil)
      expect(json[:cart][:packs]).to eq([])

      put '/carts/add', params: {
        quantity: pack.stock + 1,
        pack_id: pack.id,
        restaurant_id: restaurant.id
      }, as: :json

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('No hay stock')
    end
  end
end
