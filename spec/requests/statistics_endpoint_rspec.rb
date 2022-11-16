require 'rails_helper'

RSpec.describe 'restaurant uses statistics endpoint', type: :request do
  scenario 'for sold packs' do
    restaurant = create(:restaurant)
    purchase = create(:purchase, restaurant: restaurant, status: 1)
    restaurant_user = restaurant.restaurant_users.first

    auth = log_restaurant_user_in(restaurant_user)

    get "/restaurants/#{restaurant.id}/statistics", params: {
      kind: 'packs',
      step: 'days',
      start_date: (purchase.created_at - 2.days),
      end_date: (purchase.created_at + 3.days)
    }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:"#{purchase.created_at.to_date}"]).to eq(1)
  end

  context 'for earnings' do
    it 'response has correct statistics' do
      restaurant = create(:restaurant)
      purchase = create(:purchase, restaurant: restaurant, status: 1)
      restaurant_user = restaurant.restaurant_users.first

      auth = log_restaurant_user_in(restaurant_user)

      get "/restaurants/#{restaurant.id}/statistics", params: {
        kind: 'earnings',
        step: 'days',
        start_date: (purchase.created_at - 2.days),
        end_date: (purchase.created_at + 3.days)
      }, headers: { "HTTP_AUTHORIZATION": auth.to_s }, as: :json

      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:"#{purchase.created_at.to_date}"]).to eq(purchase.total)
    end
  end
end
