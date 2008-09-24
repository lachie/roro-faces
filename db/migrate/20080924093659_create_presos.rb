class CreatePresos < ActiveRecord::Migration
  def self.up
    create_table :presos do |t|
      t.text :description
      t.text :description_html
      
      t.boolean :allow_feedback
      
      t.belongs_to :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :presos
  end
end
