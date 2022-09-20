class CreateCategoriesPacks < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_packs, id: false do |t|
      t.references :category, null: false, foreign_key: true
      t.references :pack, null: false, foreign_key: true
    end

    add_reference :categories_packs, :packs, foreign_key: true
    add_reference :categories_packs, :categories, foreign_key: true
  end
end
