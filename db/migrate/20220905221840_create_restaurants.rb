class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.integer :status, default: 0
      t.integer :phone_number
      t.string :location
      t.string :logo

      t.timestamps
    end

    add_reference :restaurant_users, :restaurant, foreign_key: true
  end
end
