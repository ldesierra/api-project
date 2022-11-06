class AddFieldsToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :status, :integer, default: 0
    add_column :purchases, :qualification, :integer, default: 0
    add_column :purchases, :code, :string
  end
end
