

task :feeds => :environment do
  
  
  Feed.all.each {|f| f.parse!}

  # f = Group.find(2).feeds.twitter.first
  # f.feed_items.clear
  # f.parse!
end

namespace :feeds do
  task :create_group_feeds => :environment do
    Group.all.each {|g| g.create_feed}
  end
end