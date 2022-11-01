require 'rails_helper'

RSpec.describe 'qualify purchase endpoint', type: :request do
  scenario 'with a logged customer and accepted value' do
    purchase = create(:purchase, status: 2)
    customer = purchase.customer

    auth_token = log_customer_in(customer)

    put "/purchases/#{purchase.id}/qualify", params: {
      qualification: '3'
    }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }, as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq('Pedido calificado correctamente')
  end

  context 'with a logged customer and unaccepted value' do
    it 'returns error for value' do
      purchase = create(:purchase)
      customer = purchase.customer

      auth_token = log_customer_in(customer)

      put "/purchases/#{purchase.id}/qualify", params: {
        qualification: '0'
      }, headers: { "HTTP_AUTHORIZATION": auth_token.to_s }, as: :json

      expect(response.status).to eq(422)
    end
  end
end
