require 'rails_helper'

RSpec.describe 'restaurant_user reset password endpoints', type: :request do
  scenario 'with correct token sent back' do
    restaurant_user = create(:restaurant_user)

    post '/restaurant_users/password', params: {
      restaurant_user: {
        email: restaurant_user.email
      }
    }

    mail_sent = ActionMailer::Base.deliveries.last

    token = ActionMailer::Base.deliveries.first.body.match(%r{/\?token=([\w-]*)})[1]

    # response should have HTTP Status 200 Ok
    expect(response.status).to eq(200)

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq('Follow instructions sent to your mail to reset password')

    put '/restaurant_users/password', params: {
      restaurant_user: {
        reset_password_token: token,
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }

    expect(response.status).to eq(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message]).to eq('Password changed successfully')
  end

  scenario 'with incorrect token sent back' do
    restaurant_user = create(:restaurant_user)

    post '/restaurant_users/password', params: {
      restaurant_user: {
        email: restaurant_user.email
      }
    }

    mail_sent = ActionMailer::Base.deliveries.last

    ActionMailer::Base.deliveries.first.body.match(%r{/\?token=(\w*)})[1]

    # response should have HTTP Status 200 Ok
    expect(response.status).to eq(200)

    expect(mail_sent.to.first).to eq(restaurant_user.email)

    # get hash response
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:message]).to eq('Follow instructions sent to your mail to reset password')

    put '/restaurant_users/password', params: {
      restaurant_user: {
        reset_password_token: 'wrong-token',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }

    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:message].first).to eq('Reset password token no es válido')
  end
end