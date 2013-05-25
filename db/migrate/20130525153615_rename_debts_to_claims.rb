class RenameDebtsToClaims < ActiveRecord::Migration
  def up
    rename_table :debts, :claims
  end

  def down
    rename_table :claims, :debts
  end
end
