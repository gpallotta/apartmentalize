class AddEmailToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :email, :string
  end
end
