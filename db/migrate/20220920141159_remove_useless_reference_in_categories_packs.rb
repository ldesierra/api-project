class RemoveUselessReferenceInCategoriesPacks < ActiveRecord::Migration[7.0]
  def change
    remove_reference :categories_packs, :packs, foreign_key: true
    remove_reference :categories_packs, :categories, foreign_key: true
  end
end
