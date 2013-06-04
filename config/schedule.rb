every 1.day, :at => '12:00 am' do
  command "rm #{path}/tmp/capybara/capybara*"
end

every 1.day, at: => '12:00 am' do
  runner "Group.delete_empty"
end
