class AddWeeklyEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receives_weekly_email, :boolean, default: false
  end
end
