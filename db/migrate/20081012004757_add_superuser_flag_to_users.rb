class AddSuperuserFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :superuser, :boolean, :default => false
  end

  def self.down
    remove_column :users, :superuser
  end
end
