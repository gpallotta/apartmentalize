class AddUserIdToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :user_id, :integer, null: false
  end
end
