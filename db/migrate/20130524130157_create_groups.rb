class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :identifier, null: false

      t.timestamps
    end
    add_index :groups, :identifier
  end
end
