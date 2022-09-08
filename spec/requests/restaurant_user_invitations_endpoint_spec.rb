require 'rails_helper'

RSpec.describe 'restaurant_user invitations endpoints', type: :request do
  scenario 'with correct token sent back' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        restaurant_users_attributes: {
          '0': {
            email: 'tuk2i@email.com',
            phone_number: '1234',
            name: 'Name'
          }
        }
      }
    }

    expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurant solicited correctly')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    mail_sent = ActionMailer::Base.deliveries.last

    token = ActionMailer::Base.deliveries.first.body.match(/\?invitation_token=([\w-]*)/)[1]

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 12_345_678,
        password_confirmation: 12_345_678,
        invitation_token: token
      },
      restaurant: {
        status: :active
      },
      id: restaurant_user.id
    }

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invitation accepted successfully')
  end

  scenario 'with incorrect token sent back' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        restaurant_users_attributes: {
          '0': {
            email: 'tuk2i@email.com',
            phone_number: '1234',
            name: 'Name'
          }
        }
      }
    }

    expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurant solicited correctly')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    mail_sent = ActionMailer::Base.deliveries.last
    expect(mail_sent.to.first).to eq(restaurant_user.email)

    token = 'wrong_token'

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 12_345_678,
        password_confirmation: 12_345_678,
        invitation_token: token
      },
      restaurant: {
        status: :active
      },
      id: restaurant_user.id
    }

    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq(['Invitation token no es válido'])
  end

  scenario 'with correct token and restaurant active' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        restaurant_users_attributes: {
          '0': {
            email: 'tuk2i@email.com',
            phone_number: '1234',
            name: 'Name'
          }
        }
      }
    }

    expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurant solicited correctly')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    restaurant.active!
    restaurant.save

    mail_sent = ActionMailer::Base.deliveries.last

    token = ActionMailer::Base.deliveries.first.body.match(/\?invitation_token=([\w-]*)/)[1]

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 12_345_678,
        password_confirmation: 12_345_678,
        invitation_token: token
      },
      restaurant: {
        status: :active
      },
      id: restaurant_user.id
    }

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invitation accepted successfully')
  end
end
