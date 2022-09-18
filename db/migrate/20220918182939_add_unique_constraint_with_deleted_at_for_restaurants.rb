class AddUniqueConstraintWithDeletedAtForRestaurants < ActiveRecord::Migration[7.0]
  def change
    remove_index :restaurants, :name, unique: true
    add_index :restaurants, [:name, :deleted_at, :location], unique: true
  end
end
