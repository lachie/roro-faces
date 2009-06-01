class LengthenUserFields < ActiveRecord::Migration
  def self.up
    change_column :users, :crypted_password, :string, :length => 255
    change_column :users, :password_salt, :string, :length => 255

    change_column :users, :openid_identifier, :string, :null => true
  end

  def self.down
  end
end
