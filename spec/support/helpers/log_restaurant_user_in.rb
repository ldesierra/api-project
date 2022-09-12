module Helpers
  module LogRestaurantUserIn
    def log_restaurant_user_in(restaurant_user)
      post '/restaurant_users/login', params: {
        restaurant_user: {
          email: restaurant_user.email,
          password: restaurant_user.password
        }
      }

      json = JSON.parse(response.body).deep_symbolize_keys
      access_token = json[:access_token]
      two_factor_code = FakeTwilio.messages.last.body
      post '/restaurant_users/two_factor', params: {
        access_token: access_token,
        two_factor_code: two_factor_code
      }

      response.headers['Authorization']
    end
  end
end
