class AddMeetingToPreso < ActiveRecord::Migration
  def self.up
    add_column :presos, :meeting_id, :integer
  end

  def self.down
    remove_column :presos, :meeting_id
  end
end
