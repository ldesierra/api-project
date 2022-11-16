require 'rails_helper'

RSpec.describe 'restaurant_user invites another user', type: :request do
  scenario 'non logged user tries to invite and fails' do
    post '/restaurant_users/invite', params: {
      restaurant_user: {
        email: 'test@email.com',
        name: 'name',
        phone_number: '+59899999911'
      }
    }

    expect(response.status).to eq(401)
    expect(response.body).to include('authentication error')
  end

  scenario 'employee tries to invite and fails' do
    restaurant = create(:restaurant)
    restaurant_user = create(:restaurant_user, role: :employee, restaurant: restaurant)

    auth_token = log_restaurant_user_in(restaurant_user)

    post '/restaurant_users/invite', params: {
      restaurant_user: {
        email: 'test@email.com',
        name: 'name',
        phone_number: '+59899999911',
        restaurant_id: restaurant.id
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    expect(response.status).to eq(401)
    expect(response.body).to include('No estas autorizado para realizar la accion')
  end

  scenario 'manager tries to invite an incorrect user' do
    restaurant = create(:restaurant)
    restaurant_user = create(:restaurant_user, restaurant: restaurant)

    auth_token = log_restaurant_user_in(restaurant_user)

    post '/restaurant_users/invite', params: {
      restaurant_user: {
        email: 'test@email.com',
        name: 'name',
        phone_number: '+59899999911'
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    expect(response.status).to eq(422)
    expect(response.body).to include('Restaurant debe existir')
  end

  scenario 'manager tries to invite an incorrect user' do
    restaurant = create(:restaurant)
    restaurant_user = create(:restaurant_user, restaurant: restaurant)

    auth_token = log_restaurant_user_in(restaurant_user)

    post '/restaurant_users/invite', params: {
      restaurant_user: {
        email: 'test@email.com',
        name: 'name',
        phone_number: '+59899999911',
        restaurant_id: restaurant.id
      }
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }

    expect(response.status).to eq(200)
  end
end
