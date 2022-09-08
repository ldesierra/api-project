class AddJtiToRestaurantUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurant_users, :jti, :string
    add_index :restaurant_users, :jti, unique: true
  end
end
