class AddDeletedAtToRestaurantUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurant_users, :deleted_at, :datetime
    add_index :restaurant_users, :deleted_at
  end
end
