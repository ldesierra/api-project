class AddJtiToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :jti, :string
    add_index :customers, :jti, unique: true
  end
end
