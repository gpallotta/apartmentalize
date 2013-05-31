class AddPaidOnToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :paid_on, :datetime
  end
end
