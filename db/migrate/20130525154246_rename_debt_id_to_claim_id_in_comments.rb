class RenameDebtIdToClaimIdInComments < ActiveRecord::Migration
  def up
    rename_column :comments, :debt_id, :claim_id
  end

  def down
    rename_column :comments, :claim_id, :debt_id
  end
end
