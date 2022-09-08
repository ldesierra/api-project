require 'rails_helper'

RSpec.describe 'Restaurant User sign out endpoint', type: :request do
  scenario 'Auth token gets revoked' do
    restaurant_user = create(:restaurant_user)

    auth_token = log_restaurant_user_in(restaurant_user)

    expect(get('/', headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(200)

    expect(delete('/restaurant_users/sign_out',
                  headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(200)

    expect(get('/', headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(401)
  end
end
