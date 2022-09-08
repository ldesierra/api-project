require 'rails_helper'

RSpec.describe 'restaurant_user reset password endpoints', type: :request do
  scenario 'with correct token sent back' do
    restaurant_user = create(:restaurant_user)

    post '/restaurant_users/password', params: {
      restaurant_user: {
        email: restaurant_user.email
      }
    }
  end
end
