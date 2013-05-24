class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :title, null: false
      t.string :description
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.boolean :completed

      t.timestamps
    end
    add_index :chores, :group_id
    add_index :chores, :user_id
  end
end
