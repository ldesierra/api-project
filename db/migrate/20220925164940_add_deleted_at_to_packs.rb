class AddDeletedAtToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :deleted_at, :datetime
    add_index :packs, :deleted_at
  end
end
