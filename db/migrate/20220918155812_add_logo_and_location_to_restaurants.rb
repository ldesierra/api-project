class AddLogoAndLocationToRestaurants < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :status, :integer, default: 0
    add_column :restaurants, :phone_number, :integer
    add_column :restaurants, :location, :string
    add_column :restaurants, :logo, :string

    remove_column :restaurants, :active, :boolean

    add_index :restaurants, :name, unique: true
  end
end
