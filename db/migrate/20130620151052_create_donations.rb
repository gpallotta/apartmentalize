class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :email, null: false
      t.string :name

      t.timestamps
    end
  end
end
