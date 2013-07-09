task :remove_empty_groups => :environment do
  puts 'Removing empty groups...'
  Group.delete_empty
  puts 'Finished removing empty groups'
end
