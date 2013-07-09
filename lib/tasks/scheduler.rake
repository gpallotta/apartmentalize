task :remove_empty_groups => :environment do
  puts 'Removing empty groups...'
  Group.delete_empty
  puts 'Finished removing empty groups'
end

task :cycle_chores => :environment do
  puts 'Cycling chores...'
  Group.all.each do |g|
    g.cycle_chores
  end
  puts 'Finished cycling chores'
end

task :send_weekly_summaries => :environment do
  puts 'Sending weekly summaries...'
  SummaryDispatcher::WeeklySummaries.send_weekly_summary
  puts 'Finished sending weekly summaries'
end

task :send_daily_summaries => :environment do
  puts 'Sending daily summaries'
  SummaryDispatcher::DailySummaries.send_daily_summary
  puts 'Finished sending daily summaries'
end
