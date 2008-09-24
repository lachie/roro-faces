class AddGroupShortname < ActiveRecord::Migration
  def self.up
    add_column :groups, :short_name, :string
  end

  def self.down
    remove_column :groups, :short_name
  end
end
