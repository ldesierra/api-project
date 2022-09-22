require 'rails_helper'

RSpec.describe 'restaurants show endpoint', type: :request do
  scenario 'with default pagination' do
    restaurant1 = create(:restaurant)

    get "/restaurants/#{restaurant1.id}", as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:restaurant][:name]).to eq(restaurant1.name)
    expect(json[:restaurant][:description]).to eq(restaurant1.description)
    expect(json[:restaurant][:status]).to eq(restaurant1.status)
    expect(json[:restaurant][:location]).to eq(restaurant1.location)
    expect(json[:restaurant][:phone_number]).to eq(restaurant1.phone_number)
    expect(json[:restaurant][:logo].to_json).to eq(restaurant1.logo.to_json)
  end
end
