class CreateThankyous < ActiveRecord::Migration
  def self.up
    create_table :thankyous do |t|
      string :reason
      string :source, :limit => 8
      
      foreign_key :from
      foreign_key :to
      
      timestamps!
    end
  end

  def self.down
    drop_table :thankyous
  end
end
