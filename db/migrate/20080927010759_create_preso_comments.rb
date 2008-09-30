class CreatePresoComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.belongs_to :commentable, :polymorphic => true
      t.belongs_to :user
      
      t.text :comment
      t.text :comment_html

      t.timestamps
    end
    
    create_table :preso_ratings do |t|
      t.belongs_to :preso
      t.belongs_to :user
      
      t.integer :content
      t.integer :length
      t.integer :slides
      
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
    drop_table :preso_rating
  end
end
