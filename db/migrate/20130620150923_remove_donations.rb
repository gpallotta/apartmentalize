class RemoveDonations < ActiveRecord::Migration
  def up
    drop_table :donations
  end

  def down
    create_table :donations
  end
end
