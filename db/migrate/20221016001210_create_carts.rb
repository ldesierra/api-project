class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :customer, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.float :total

      t.timestamps
    end
  end
end
