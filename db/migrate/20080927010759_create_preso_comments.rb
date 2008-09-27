class CreatePresoComments < ActiveRecord::Migration
  def self.up
    create_table :preso_comments do |t|
      t.belongs_to :preso
      t.belongs_to :user
      
      t.text :comment
      t.text :comment_html
      
      t.integer :rating_content
      t.integer :rating_length
      t.integer :rating_slides
      
      t.timestamps
    end
  end

  def self.down
    drop_table :preso_comments
  end
end
