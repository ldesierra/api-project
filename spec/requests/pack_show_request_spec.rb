require 'rails_helper'

RSpec.describe 'packs show endpoint', type: :request do
  scenario 'with default pagination' do
    pack = create(:pack)

    get "/packs/#{pack.id}", as: :json

    expect(response.status).to eq(200)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:pack][:name]).to eq(pack.name)
    expect(json[:pack][:stock]).to eq(pack.stock)
    expect(json[:pack][:short_description]).to eq(pack.short_description)
    expect(json[:pack][:full_description]).to eq(pack.full_description)
    expect(json[:pack][:price]).to eq(pack.price.to_f.to_s)
    expect(json[:pack][:restaurant_id]).to eq(pack.restaurant_id)
  end
end
