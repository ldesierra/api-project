require 'rails_helper'

RSpec.describe 'pack update endpoint', type: :request do
  scenario 'with correct params' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first
    pack = create(:pack, restaurant: restaurant)

    auth_token = log_restaurant_user_in(restaurant_user)

    put "/restaurants/#{restaurant.id}/packs/#{pack.id}", params: {
      pack: {
        name: 'new pack name',
        price: '34',
        stock: '10'
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    pack.reload

    expect(response.status).to eq(200)

    expect(pack.name).to eq('new pack name')
    expect(pack.price).to eq(34)
    expect(pack.stock).to eq(10)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Pack actualizado correctamente')
  end

  scenario 'with incorrect params (no name)' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first
    pack = create(:pack, restaurant: restaurant)
    last_name = pack.name

    auth_token = log_restaurant_user_in(restaurant_user)

    put "/restaurants/#{restaurant.id}/packs/#{pack.id}", params: {
      pack: {
        name: '',
        price: '34',
        stock: '10'
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    pack.reload

    expect(response.status).to eq(422)

    expect(pack.name).to eq(last_name)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq(['Name no puede estar en blanco'])
  end
end
