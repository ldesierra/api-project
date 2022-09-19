class CreatePacks < ActiveRecord::Migration[7.0]
  def change
    create_table :packs do |t|
      t.string :name
      t.integer :stock
      t.text :description
      t.decimal :price

      t.timestamps
    end

    add_reference :packs, :restaurant, foreign_key: true
  end
end
