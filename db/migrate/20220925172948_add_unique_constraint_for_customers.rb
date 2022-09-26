class AddUniqueConstraintForCustomers < ActiveRecord::Migration[7.0]
  def change
    remove_index :customers, :email, unique: true
    add_index :customers, [:email, :deleted_at], unique: true
    add_index :customers, [:username, :deleted_at], unique: true
  end
end
