require 'rails_helper'

RSpec.describe 'purchases index endpoint', type: :request do
  scenario 'with a logged customer' do
    purchase = create(:purchase)
    customer = purchase.customer

    auth_token = log_customer_in(customer)

    get '/purchases', headers: { "HTTP_AUTHORIZATION": auth_token.to_s }, as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:purchases].size).to eq(1)
    expect(json[:purchases][0][:customer_id]).to eq(customer.id)
  end
end
