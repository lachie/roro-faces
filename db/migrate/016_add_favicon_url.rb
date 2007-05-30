class AddFaviconUrl < ActiveRecord::Migration
  def self.up
    add_column :facet_kinds, :favicon_url, :string
  end

  def self.down
    remove_column :facet_kinds, :favicon_url
  end
end
