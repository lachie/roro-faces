# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080924114455) do

  create_table "affiliations", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "regular"
    t.boolean "visitor"
    t.boolean "presenter"
  end

  create_table "entries", :force => true do |t|
    t.datetime "date_published"
    t.string   "authors"
    t.text     "content"
    t.text     "description"
    t.string   "title"
    t.integer  "user_id"
  end

  create_table "facet_kinds", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "service_url"
    t.string  "title"
    t.string  "site"
    t.string  "feed"
    t.boolean "aggregatable"
    t.string  "favicon_url"
  end

  create_table "facets", :force => true do |t|
    t.string  "name"
    t.string  "info",          :null => false
    t.integer "user_id",       :null => false
    t.integer "facet_kind_id", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name",       :null => false
    t.string  "url"
    t.boolean "once_off"
    t.string  "short_name"
  end

  create_table "meetings", :force => true do |t|
    t.string  "where",    :null => false
    t.integer "group_id"
    t.date    "date"
  end

  create_table "mugshots", :force => true do |t|
    t.integer "size"
    t.string  "filename"
    t.string  "content_type"
    t.integer "height"
    t.integer "width"
    t.string  "thumbnail"
    t.integer "parent_id"
  end

  add_index "mugshots", ["parent_id"], :name => "index_mugshots_on_parent_id"

  create_table "presentations", :force => true do |t|
    t.integer "user_id"
    t.integer "meeting_id"
    t.string  "title",      :null => false
  end

  create_table "presos", :force => true do |t|
    t.text     "description"
    t.text     "description_html"
    t.boolean  "allow_feedback"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "meeting_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "thankyous", :force => true do |t|
    t.string   "reason"
    t.string   "source",     :limit => 8
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thankyous", ["from_id"], :name => "index_thankyous_on_from_id"
  add_index "thankyous", ["to_id"], :name => "index_thankyous_on_to_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "mugshot_id"
    t.string   "irc_nick"
    t.string   "blurb"
    t.string   "aliases"
    t.string   "location"
    t.string   "name"
    t.string   "site_url"
    t.string   "site_name"
    t.boolean  "admin",                                   :default => false
    t.string   "working_at"
    t.string   "working_at_url"
    t.string   "working_on"
    t.string   "site_feed"
    t.datetime "site_feed_last_updated"
    t.string   "site_feed_title"
    t.string   "site_feed_desc"
    t.string   "alternate_irc_nick"
    t.string   "mugshot_file_name"
    t.string   "mugshot_content_type"
    t.integer  "mugshot_file_size"
    t.datetime "mugshot_updated_at"
  end

end
