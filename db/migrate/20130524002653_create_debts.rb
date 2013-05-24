class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.string :title, null: false
      t.string :description, limit: 200
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.boolean :paid, null: false, default: false

      t.timestamps
    end
  end
end
