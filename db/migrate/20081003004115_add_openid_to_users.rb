class AddOpenidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :openid, :string, :null => false
  end

  def self.down
    remove_column :users, :openid
  end
end
