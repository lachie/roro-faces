class CreatePresoComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.belongs_to :commentable, :polymorphic => true
      t.belongs_to :user
      
      t.text :comment
      t.text :comment_html

      t.timestamps
    end
    
    create_table :preso_rating do |t|
      t.belongs_to :preso
      t.belongs_to :user
      
      t.integer :rating_content
      t.integer :rating_length
      t.integer :rating_slides
      
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
    drop_table :preso_rating
  end
end
