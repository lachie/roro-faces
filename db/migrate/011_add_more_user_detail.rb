class AddMoreUserDetail < ActiveRecord::Migration
  def self.up
    add_column :users, :working_at, :string
    add_column :users, :working_at_url, :string
    add_column :users, :working_on, :string

  end

  def self.down
    remove_column :users, :working_at
    remove_column :users, :working_on
    remove_column :users, :working_at_url
  end
end
