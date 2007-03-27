class CreateFacets < ActiveRecord::Migration
  def self.up
    create_table :facets do |t|
      t.column :name, :string
      t.column :info, :string, :null => false
      t.column :user_id, :integer, :null => false
      t.column :facet_kind_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :facets
  end
end
