task :feeds => :environment do

  f = Group.find(2).feeds.twitter.first
  f.feed_items.clear
  f.parse!
end