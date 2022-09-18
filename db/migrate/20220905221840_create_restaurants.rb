class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: false

      t.timestamps
    end

    add_reference :restaurant_users, :restaurant, foreign_key: true
  end
end
