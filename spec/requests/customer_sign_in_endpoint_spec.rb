require 'rails_helper'

RSpec.describe 'Customer sign in endpoint', type: :request do
  scenario 'with correct email and password' do
    customer = create(:customer)

    post '/customers/sign_in', params: {
      customer: {
        email: customer.email,
        password: customer.password
      }
    }

    # response should have HTTP Status 200 Ok
    expect(response.status).to eq(200)

    expect(response.headers['Authorization']).to_not eq(nil)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq('Logged in successfuly')

    expect(get('/',
               headers: { "HTTP_AUTHORIZATION":
                          response.headers['Authorization'].to_s })).to eq(200)
  end

  scenario 'with incorrect email or password' do
    customer = create(:customer)

    post '/customers/sign_in', params: {
      customer: {
        email: 'wrong email',
        password: customer.password
      }
    }

    expect(response.status).to eq(401)

    expect(response.headers['Authorization']).to eq(nil)
  end
end
