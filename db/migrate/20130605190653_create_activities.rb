class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :owner_id
      t.integer :recipient_id
      t.string :action
      t.belongs_to :trackable
      t.string :trackable_type

      t.timestamps
    end
    add_index :activities, :owner_id
    add_index :activities, :recipient_id
    add_index :activities, :trackable_id
  end
end
