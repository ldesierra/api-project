class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.string :image
      t.references :imageable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
