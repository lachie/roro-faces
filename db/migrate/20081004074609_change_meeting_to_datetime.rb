class ChangeMeetingToDatetime < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :date
    add_column :meetings, :date, :datetime
  end

  def self.down
  end
end
