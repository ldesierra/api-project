require 'rails_helper'

RSpec.describe 'restaurant user soft deletes packs', type: :request do
  scenario 'non authorized user' do
    pack = create(:pack)
    restaurant = create(:restaurant)
    restaurant_user = restaurant.restaurant_users.first

    restaurant_user.confirm
    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    delete "/packs/#{pack.id}", as: :json

    expect(response.status).to eq(401)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('No estas autorizado para realizar la accion')
  end

  scenario 'authorized user deletes pack' do
    pack = create(:pack)
    restaurant_user = pack.restaurant.restaurant_users.first

    auth_token = log_restaurant_user_in(restaurant_user)

    delete "/packs/#{pack.id}", headers: { "HTTP_AUTHORIZATION": auth_token.to_s }, as: :json

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Pack eliminado correctamente')
  end

  scenario 'authorized user with soft deleted pack' do
    pack = create(:pack)
    restaurant_user = pack.restaurant.restaurant_users.first

    restaurant_user.confirm
    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    pack.destroy
    pack.reload

    delete "/packs/#{pack.id}", as: :json

    expect(response.status).to eq(404)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Pack no encontrado')
  end
end
