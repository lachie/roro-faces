class AddTimestampsToMeetings < ActiveRecord::Migration
  def self.up
    add_timestamps :meetings
  end

  def self.down
  end
end
