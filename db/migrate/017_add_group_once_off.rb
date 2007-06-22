class AddGroupOnceOff < ActiveRecord::Migration
  def self.up
    add_column :groups, :once_off, :boolean
  end

  def self.down
    remove_column :groups, :once_off
  end
end
