class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, null: false
      t.integer :user_id, null: false
      t.integer :debt_id, null: false

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :debt_id
  end
end
