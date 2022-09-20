require 'rails_helper'

RSpec.describe 'Restaurant user two factor endpoint', type: :request do
  scenario 'with correct code and access token' do
    restaurant_user = create(:restaurant).restaurant_users.first
    restaurant_user.confirm
    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    json = JSON.parse(response.body).deep_symbolize_keys

    # get access token from login request
    access_token = json[:access_token]

    # get two factor code from messages
    two_factor_code = FakeTwilio.messages.last.body

    post '/restaurant_users/two_factor', params: {
      access_token: access_token,
      two_factor_code: two_factor_code
    }

    # after authenticating with 2fa should be logged in
    expect(response.status).to eq(200)

    expect(response.headers['Authorization']).to_not eq(nil)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Logged in successfully')
  end

  scenario 'with incorrect access token' do
    restaurant_user = create(:restaurant).restaurant_users.first

    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    post '/restaurant_users/two_factor', params: {
      access_token: 'wrong token',
      two_factor_code: 'code'
    }

    expect(response.status).to eq(401)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invalid request')
  end

  scenario 'with incorrect two factor code' do
    restaurant_user = create(:restaurant).restaurant_users.first
    restaurant_user.confirm

    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    json = JSON.parse(response.body).deep_symbolize_keys

    # get access token from login request
    access_token = json[:access_token]

    post '/restaurant_users/two_factor', params: {
      access_token: access_token,
      two_factor_code: 'wrong code'
    }

    expect(response.status).to eq(401)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invalid code, try again')
  end

  scenario 'with a request to get second code with correct access token' do
    restaurant_user = create(:restaurant).restaurant_users.first
    restaurant_user.confirm
    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    # get access token from login request
    access_token = json[:access_token]

    post '/restaurant_users/request_two_factor', params: {
      access_token: access_token
    }

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Ya ha solicitado un código en los últimos 2 minutos')
    expect(response.status).to eq(401)
  end

  scenario 'with a request to get second code with incorrect access token' do
    restaurant_user = create(:restaurant).restaurant_users.first
    restaurant_user.confirm
    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }

    expect(response.status).to eq(200)

    post '/restaurant_users/request_two_factor', params: {
      access_token: 'wrong-token'
    }

    expect(response.status).to eq(401)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Invalid request')
  end
end
