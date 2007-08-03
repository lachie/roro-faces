class AddThankyouIndexes < ActiveRecord::Migration
  def self.up
    add_index :thankyous, :from_id
    add_index :thankyous, :to_id
    add_index :mugshots, :parent_id
  end

  def self.down
    remove_index :thankyous, :from_id
    remove_index :thankyous, :to_id
    remove_index :mugshots, :parent_id
  end
end
