require 'rails_helper'

RSpec.describe 'category index endpoint', type: :request do
  scenario 'with default pagination' do
    category1 = create(:category)
    category2 = create(:category)

    get '/categories', as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:categories].size).to eq(2)

    expect(json[:categories][0][:name]).to eq(category1.name)
    expect(json[:categories][1][:name]).to eq(category2.name)
  end
end
