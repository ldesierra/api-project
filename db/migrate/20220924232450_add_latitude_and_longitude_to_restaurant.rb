class AddLatitudeAndLongitudeToRestaurant < ActiveRecord::Migration[7.0]
  def change
    rename_column :restaurants, :location, :address
    add_column :restaurants, :latitude, :decimal
    add_column :restaurants, :longitude, :decimal
  end
end
