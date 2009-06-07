class AddBlogTimestamps < ActiveRecord::Migration
  def self.up
    add_column :meetings, :blog_created_at, :timestamp
    add_column :meetings, :blog_updated_at, :timestamp
  end

  def self.down
  end
end
