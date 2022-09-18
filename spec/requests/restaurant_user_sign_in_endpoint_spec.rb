require 'rails_helper'

RSpec.describe 'Restaurant user sign in endpoint', type: :request do
  scenario 'with correct email and password' do
    restaurant_user = create(:restaurant_user)
    restaurant_user.confirm

    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: restaurant_user.email,
        password: restaurant_user.password
      }
    }
    # response should have HTTP Status 200 Ok
    expect(response.status).to eq(200)

    # but it shouldnt bring Authorization header because 2fa verification was not done
    expect(response.headers['Authorization']).to eq(nil)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check that the returned response has access token for 2fa
    expect(json[:access_token]).to_not eq(nil)
  end

  scenario 'with incorrect email or password' do
    restaurant_user = create(:restaurant_user)

    post '/restaurant_users/login', params: {
      restaurant_user: {
        email: 'wrong email',
        password: restaurant_user.password
      }
    }

    expect(response.status).to eq(401)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:error]).to eq('authentication error')
  end
end
