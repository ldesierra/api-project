class CreateOpenHours < ActiveRecord::Migration[7.0]
  def change
    create_table :open_hours do |t|
      t.integer :day
      t.time :start_time
      t.time :end_time

      t.timestamps
    end

    add_reference :open_hours, :restaurant, foreign_key: true
  end
end
