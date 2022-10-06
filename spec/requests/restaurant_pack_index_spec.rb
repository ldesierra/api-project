require 'rails_helper'

RSpec.describe 'restaurants packs index endpoint', type: :request do
  scenario 'with default pagination' do
    restaurant = create(:restaurant, address: 'Soul Buoy')
    pack1 = create(:pack, restaurant: restaurant)
    pack2 = create(:pack, restaurant: restaurant)
    restaurant_user = restaurant.restaurant_users.first

    auth_token = log_restaurant_user_in(restaurant_user)

    get "/restaurants/#{restaurant.id}/packs", headers: { "HTTP_AUTHORIZATION": auth_token.to_s },
                                               as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:packs].size).to eq(2)

    expect(json[:packs][0][:name]).to eq(pack1.name)
    expect(json[:packs][1][:name]).to eq(pack2.name)
  end
end
