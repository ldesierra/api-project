require 'rails_helper'

RSpec.describe 'Customer sign up endpoint', type: :request do
  scenario 'with correct email format and password' do
    new_customer_email = Faker::Internet.email
    new_customer_password = Faker::Internet.password

    post '/customers/sign_up', params: {
      customer: {
        email: new_customer_email,
        password: new_customer_password,
        username: Faker::Internet.username,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone: '+59899999999'
      }
    }

    # response should have HTTP Status 201 Created
    expect(response.status).to eq(201)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq('Signed up successfully')

    # new Customer was created
    expect(Customer.count).to eq(1)
    expect(Customer.last.email).to eq(new_customer_email)
  end

  scenario 'with missing field' do
    post '/customers/sign_up', params: {
      customer: {
        password: Faker::Internet.password,
        username: Faker::Internet.username,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone: Faker::PhoneNumber.phone_number
      }
    }

    # response should have HTTP Status 422 unprocessable entity
    expect(response.status).to eq(422)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq(['Email no puede estar en blanco', 'Email no es válido',
                                  'Celular no es válido'])

    # Customer was not created
    expect(Customer.count).to eq(0)
  end
end
