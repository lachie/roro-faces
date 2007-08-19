class AddAlternateNickToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :alternate_irc_nick, :string
  end

  def self.down
    remove_column :users, :alternate_irc_nick
  end
end
