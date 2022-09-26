require 'rails_helper'

RSpec.describe 'restaurants index endpoint', type: :request do
  scenario 'with default pagination' do
    restaurant1 = create(:restaurant, latitude: 0, longitude: 0)
    restaurant2 = create(:restaurant)

    get '/restaurants', as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:restaurants].size).to eq(2)

    expect(json[:restaurants][0][:name]).to eq(restaurant1.name)
    expect(json[:restaurants][1][:name]).to eq(restaurant2.name)
  end

  scenario 'with custom pagination params' do
    create(:restaurant)
    create(:restaurant)

    get '/restaurants', params: {
      page: '1',
      items: '1'
    }, as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:restaurants].size).to eq(1)
  end
end
