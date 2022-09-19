class CreatePackCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :pack_categories do |t|

      t.timestamps
    end

    add_reference :pack_categories, :pack, foreign_key: true
    add_reference :pack_categories, :category, foreign_key: true
  end
end
