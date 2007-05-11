class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      datetime :when, :null => false
      string :where, :null => false
      foreign_key :group
    end
  end

  def self.down
    drop_table :meetings
  end
end
