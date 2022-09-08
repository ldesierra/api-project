class AddPhoneNumberToRestaurantUser < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurant_users, :phone_number, :string
  end
end
