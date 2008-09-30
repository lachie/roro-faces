class CreateFeedsAndItems < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      
      t.belongs_to :feedable, :polymorphic => true
      
      t.string :nominal_type
      
      t.string :url
      t.string :feed_url
      
      t.string :uuid
      
      t.timestamp :fetched_at
      
      t.string :title
      t.string :description
      
      t.timestamps
    end
    
    create_table :feed_items do |t|
      t.belongs_to :feed
      
      t.string :uuid
      
      t.string :title
      t.text :body
      t.string :url
      
      t.string :author_name
      t.string :author_email
      t.string :author_url
      
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
    drop_table :feed_items
  end
end
