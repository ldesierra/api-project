class AddConfirmableToDevise < ActiveRecord::Migration[7.0]
  # Note: You can't use change, as User.update_all will fail in the down migration
  def up
    add_column :restaurant_users, :confirmation_token, :string
    add_column :restaurant_users, :confirmed_at, :datetime
    add_column :restaurant_users, :confirmation_sent_at, :datetime
    # add_column :restaurant_users, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :restaurant_users, :confirmation_token, unique: true
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # restaurant_users as confirmed, do the following
    RestaurantUser.update_all confirmed_at: DateTime.now
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_index :restaurant_users, :confirmation_token
    remove_columns :restaurant_users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :restaurant_users, :unconfirmed_email # Only if using reconfirmable
  end
end
