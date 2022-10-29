require 'rails_helper'

RSpec.describe 'restaurant update endpoint', type: :request do
  scenario 'with correct params' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first

    auth_token = log_restaurant_user_in(restaurant_user)

    put "/restaurants/#{restaurant.id}", params: {
      restaurant: {
        name: 'new restaurant name',
        latitude: '34',
        longitude: '10',
        phone_number: '+59899999999'
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    restaurant.reload

    expect(response.status).to eq(200)

    expect(restaurant.name).to eq('new restaurant name')
    expect(restaurant.latitude).to eq(34)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Restaurante actualizado correctamente')
  end

  scenario 'with incorrect params (no name)' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first
    last_name = restaurant.name

    auth_token = log_restaurant_user_in(restaurant_user)

    put "/restaurants/#{restaurant.id}", params: {
      restaurant: {
        name: '',
        latitude: '34',
        longitude: '10',
        phone_number: '+59899999999'
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    restaurant.reload

    expect(response.status).to eq(422)
    expect(restaurant.name).to eq(last_name)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Error al actualizar restaurante')
  end
end
