class CreateJointTables < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_packs do |t|
      t.references :pack, null: false, foreign_key: true
      t.references :purchase, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end

    create_table :cart_packs do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :pack, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
