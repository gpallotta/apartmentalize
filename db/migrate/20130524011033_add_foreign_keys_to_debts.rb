class AddForeignKeysToDebts < ActiveRecord::Migration
  def up
    add_column :debts, :user_owed_to_id, :integer, :null => false
    add_column :debts, :user_who_owes_id, :integer, :null => false
    add_index :debts, :user_owed_to_id
    add_index :debts, :user_who_owes_id
  end

  def down
    remove_column :debts, :user_owed_to_id
    remove_column :debts, :user_who_owes_id
  end
end
