require 'rails_helper'

RSpec.describe 'Customer sign out endpoint', type: :request do
  scenario 'Auth token gets revoked' do
    customer = create(:customer)

    auth_token = log_customer_in(customer)

    expect(get('/', headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(200)

    expect(delete('/customers/sign_out',
                  headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(200)

    expect(get('/', headers: { "HTTP_AUTHORIZATION": auth_token.to_s })).to eq(401)
  end
end
