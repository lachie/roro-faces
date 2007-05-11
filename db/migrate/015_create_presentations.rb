class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      foreign_key :user, :meeting
      string :title, :null => false
    end
  end

  def self.down
    drop_table :presentations
  end
end
