class AddRenameWhen < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :when
    add_column :meetings, :date, :date
  end

  def self.down
    remove_column :meetings, :date
    add_column :meetings, :when, :date
  end
end
