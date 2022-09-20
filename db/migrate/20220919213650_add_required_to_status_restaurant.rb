class AddRequiredToStatusRestaurant < ActiveRecord::Migration[7.0]
  def change
    Restaurant.where(status: nil).update_all(status: :pending)

    change_column_null :restaurants, :status, false
  end
end
