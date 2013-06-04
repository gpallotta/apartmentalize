class AddUniquenessToGroupIdentifierIndex < ActiveRecord::Migration
  def up
    remove_index :groups, :identifier
    add_index :groups, :identifier, :unique => true
  end

  def down
    remove_index :groups, :identifier
    add_index :groups, :identifier
  end
end
