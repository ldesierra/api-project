require 'rails_helper'

RSpec.describe 'pack create endpoint', type: :request do
  scenario 'with correct params' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first
    category = create(:category)

    auth_token = log_restaurant_user_in(restaurant_user)

    post "/restaurants/#{restaurant.id}/packs", params: {
      pack: {
        name: 'pack name',
        price: '34',
        stock: '10',
        full_description: 'description full',
        short_description: 'description short',
        categories: { id: category.id }
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    restaurant.reload

    expect(response.status).to eq(201)

    expect(restaurant.packs.size).to eq(1)

    pack = restaurant.packs.first

    expect(pack.name).to eq('pack name')
    expect(pack.price).to eq(34)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Pack creado correctamente')
  end

  scenario 'with incorrect params (no name)' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    restaurant_user = restaurant.restaurant_users.first
    category = create(:category)

    auth_token = log_restaurant_user_in(restaurant_user)

    post "/restaurants/#{restaurant.id}/packs", params: {
      pack: {
        name: '',
        price: '34',
        stock: '10',
        full_description: 'description full',
        short_description: 'description short',
        categories: { id: category.id }
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    restaurant.reload

    expect(response.status).to eq(422)

    expect(restaurant.packs.size).to eq(0)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq(['Name no puede estar en blanco'])
  end
end
