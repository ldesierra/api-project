class AddUniqueConstraintForRestaurantUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :restaurant_users, :email, unique: true
    add_index :restaurant_users, [:email, :deleted_at], unique: true
  end
end
