class AddOtpAccessToken < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurant_users, :otp_access_token, :string
  end
end
