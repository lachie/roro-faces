class AddRepos < ActiveRecord::Migration
  def self.up
    create_table('repos') do |t|
      t.string :username
      t.string :name
      t.text   :description
      t.string :url

      t.boolean :fork
      t.integer :forks
      t.integer :watchers

      t.integer :score

      t.belongs_to :user
    end
  end

  def self.down
  end
end
