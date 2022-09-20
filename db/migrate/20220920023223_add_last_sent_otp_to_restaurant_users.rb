class AddLastSentOtpToRestaurantUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurant_users, :last_sent_otp, :datetime
  end
end
