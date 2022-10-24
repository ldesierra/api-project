require 'rails_helper'

RSpec.describe 'restaurant_user invitations endpoints', type: :request do
  scenario 'with correct token sent back' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        phone_number: '+59899999999',
        latitude: 0,
        longitude: 0,
        restaurant_users_attributes: {
          '0': {
            email: 'test@email.com',
            phone_number: '+59899999999',
            name: 'Name'
          }
        }
      }
    }

    # expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurante solicitado correctamente')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    mail_sent = ActionMailer::Base.deliveries.last

    token = ActionMailer::Base.deliveries.first.body.match(/\?invitation_token=([\w-]*)/)[1]

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 'password',
        password_confirmation: 'password',
        invitation_token: token
      },
      restaurant: {
        description: 'Restaurant description',
        open_hours_attributes: {
          '0': {
            day: 'monday',
            start_time: '00:00',
            end_time: '02:00'
          }
        }
      }
    }

    expect(response.status).to eq(200)

    restaurant_user.reload
    restaurant.reload

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invitation accepted successfully')
    expect(restaurant_user.encrypted_password?).to eq(true)
    expect(restaurant.active?).to eq(true)
  end

  scenario 'with incorrect token sent back' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        phone_number: '+59899999999',
        latitude: 0,
        longitude: 0,
        restaurant_users_attributes: {
          '0': {
            email: 'test@email.com',
            phone_number: '+59899999999',
            name: 'Name'
          }
        }
      }
    }

    expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurante solicitado correctamente')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    mail_sent = ActionMailer::Base.deliveries.last
    expect(mail_sent.to.first).to eq(restaurant_user.email)

    token = 'wrong_token'

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 'password',
        password_confirmation: 'password',
        invitation_token: token
      },
      restaurant: {
        description: 'Restaurant description'
      }
    }

    restaurant_user.reload
    restaurant.reload

    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq(['Invitation token no es válido'])
    expect(restaurant_user.encrypted_password?).to eq(false)
    expect(restaurant.active?).to eq(false)
  end

  scenario 'with correct token and restaurant active' do
    post '/restaurants', params: {
      restaurant: {
        name: 'Test',
        phone_number: '+59899999999',
        latitude: 0,
        longitude: 0,
        restaurant_users_attributes: {
          '0': {
            email: 'test@email.com',
            phone_number: '+59899999999',
            name: 'Name'
          }
        }
      }
    }

    expect(response.status).to eq(200)
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:message]).to eq('Restaurante solicitado correctamente')

    restaurant = Restaurant.first
    restaurant_user = RestaurantUser.first

    AcceptRestaurant.call(restaurant: restaurant, manager: restaurant_user)

    restaurant.description = 'Restaurant description'
    restaurant.open_hours_attributes = {
      '0': {
        day: 'monday',
        start_time: '00:00',
        end_time: '02:00'
      }
    }
    restaurant.active!
    restaurant.save

    mail_sent = ActionMailer::Base.deliveries.last

    token = ActionMailer::Base.deliveries.first.body.match(/\?invitation_token=([\w-]*)/)[1]

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    put '/restaurant_users/confirm_invite', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: 'password',
        password_confirmation: 'password',
        invitation_token: token
      },
      restaurant: {
        description: 'Restaurant description'
      }
    }

    restaurant_user.reload
    restaurant.reload

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invitation accepted successfully')
    expect(restaurant_user.encrypted_password?).to eq(true)
    expect(restaurant.active?).to eq(true)
  end
end
