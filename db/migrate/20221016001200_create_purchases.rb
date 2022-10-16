class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.float :total

      t.timestamps
    end
  end
end
