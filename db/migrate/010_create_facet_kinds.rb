class CreateFacetKinds < ActiveRecord::Migration
  def self.up
    create_table :facet_kinds do |t|
      t.column :name, :string, :null => false
      t.column :service_url, :string
      t.column :title, :string
      t.column :site, :string
      t.column :feed, :string
      t.column :aggregatable, :boolean
    end
  end

  def self.down
    drop_table :facet_kinds
  end
end
