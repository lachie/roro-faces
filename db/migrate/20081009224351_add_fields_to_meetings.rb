class AddFieldsToMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :spiel, :text
    add_column :meetings, :spiel_html, :text
    add_column :meetings, :analogue_blog, :text
    add_column :meetings, :analogue_blog_html, :text
  end

  def self.down
    remove_column :meetings, :spiel
    remove_column :meetings, :spiel_html
    remove_column :meetings, :analogue_blog
    remove_column :meetings, :analogue_blog_html
  end
end
