class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :title, null: false
      t.string :name, null: false
      t.string :phone_number, null: false
      t.string :address, null: false
      t.integer :group_id, null: false

      t.timestamps
    end
    add_index :managers, :group_id
  end
end
