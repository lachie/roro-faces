class CreateMugshots < ActiveRecord::Migration
  create_table "mugshots", :force => true do |t|
    t.column "size",         :integer
    t.column "filename",     :string
    t.column "content_type", :string
    t.column "height",       :integer
    t.column "width",        :integer
    t.column "thumbnail",    :string
    t.column "parent_id",    :integer
  end

  def self.down
  end
end
