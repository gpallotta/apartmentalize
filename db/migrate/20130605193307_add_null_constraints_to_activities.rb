class AddNullConstraintsToActivities < ActiveRecord::Migration
  def up
    change_column :activities, :owner_id, :integer, :null => false
    change_column :activities, :recipient_id, :integer, :null => false
  end

  def down
    change_column :activities, :owner_id, :integer
    change_column :activities, :recipient_id, :integer
  end
end
