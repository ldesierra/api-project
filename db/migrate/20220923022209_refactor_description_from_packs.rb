class RefactorDescriptionFromPacks < ActiveRecord::Migration[7.0]
  def change
    rename_column :packs, :description, :full_description
    add_column :packs, :short_description, :text
  end
end
