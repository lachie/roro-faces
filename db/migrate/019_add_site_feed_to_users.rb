class AddSiteFeedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :site_feed, :string
    add_column :users, :site_feed_last_updated, :datetime
    add_column :users, :site_feed_title, :string
    add_column :users, :site_feed_desc, :string
  end

  def self.down
    remove_column :users, :site_feed
    remove_column :users, :site_feed_last_entry
    remove_column :users, :site_feed_title
    remove_column :users, :site_feed_desc
  end
end
