task :remove_empty_groups => :environment do
  puts 'Removing empty groups...'
  Group.delete_empty
  puts 'Finished removing empty groups'
end

task :cycle_chores => :environment do
  if Time.now.sunday?
    puts 'Cycling chores...'
    Group.all.each do |g|
      g.cycle_chores
    end
    puts 'Finished cycling chores'
  end
end

task :send_weekly_summaries => :environment do
  if Time.now.sunday?
    puts 'Sending weekly summaries...'
    SummaryDispatcher::WeeklySummary.send_weekly_summary
    puts 'Finished sending weekly summaries'
  end
end

task :send_daily_summaries => :environment do
  puts 'Sending daily summaries'
  SummaryDispatcher::DailySummary.send_daily_summary
  puts 'Finished sending daily summaries'
end
