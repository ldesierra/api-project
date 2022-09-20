class CreateCategoriesPacks < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_packs, id: false do |t|
      t.bigint :category_id
      t.bigint :pack_id
    end

    add_index :categories_packs, :category_id
    add_index :categories_packs, :pack_id
  end
end
