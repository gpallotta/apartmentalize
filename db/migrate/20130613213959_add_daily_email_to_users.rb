class AddDailyEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receives_daily_email, :boolean, :default => false
  end
end
