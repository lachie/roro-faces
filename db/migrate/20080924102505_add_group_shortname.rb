class AddGroupShortname < ActiveRecord::Migration
  def self.up
    add_column :groups, :short_name, :string
    add_column :groups, :twitter_hashtag, :string
  end

  def self.down
    remove_column :groups, :short_name
    remove_column :groups, :twitter_hashtag
  end
end
