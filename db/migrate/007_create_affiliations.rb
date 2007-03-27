class CreateAffiliations < ActiveRecord::Migration
  def self.up
    create_table :affiliations, :force => true do |t|
      t.column :user_id  , :integer
      t.column :group_id , :integer
      
      t.column :regular  , :boolean
      t.column :visitor  , :boolean
      t.column :presenter, :boolean
    end
  end

  def self.down
    drop_table :affiliations
  end
end
