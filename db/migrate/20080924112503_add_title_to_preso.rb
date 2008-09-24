class AddTitleToPreso < ActiveRecord::Migration
  def self.up
    add_column :presos, :title, :string
  end

  def self.down
    remove_column :presos, :title
  end
end
