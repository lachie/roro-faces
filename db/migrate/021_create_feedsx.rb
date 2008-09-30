class CreateFeedsx < ActiveRecord::Migration
  def self.up    
    create_table :entries , :force => true do |t|
      t.column  :date_published , :datetime
      t.column  :authors , :string
      t.column  :content , :text
      t.column  :description , :text
      t.column  :title , :string
      t.column  :user_id , :integer
    end
  end
  
  def self.down
    drop_table :entries
  end
  
end