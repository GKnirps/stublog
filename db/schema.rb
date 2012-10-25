# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121016183039) do

  create_table "blogposts", :force => true do |t|
    t.string   "caption"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "category_id"
  end

  add_index "blogposts", ["category_id"], :name => "index_blogposts_on_category_id"
  add_index "blogposts", ["user_id", "created_at"], :name => "index_blogposts_on_user_id_and_created_at"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "caption"
    t.text     "content"
    t.integer  "predecessor_id"
    t.string   "predecessor_type"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["predecessor_id"], :name => "index_comments_on_predecessor_id"

  create_table "hosted_files", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "public"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "mime_type"
  end

  add_index "hosted_files", ["name"], :name => "index_hosted_files_on_name", :unique => true
  add_index "hosted_files", ["user_id"], :name => "index_hosted_files_on_user_id"

  create_table "post_tag_relationships", :force => true do |t|
    t.integer  "blogpost_id"
    t.integer  "tag_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "post_tag_relationships", ["blogpost_id", "tag_id"], :name => "index_post_tag_relationships_on_blogpost_id_and_tag_id", :unique => true
  add_index "post_tag_relationships", ["blogpost_id"], :name => "index_post_tag_relationships_on_blogpost_id"
  add_index "post_tag_relationships", ["tag_id"], :name => "index_post_tag_relationships_on_tag_id"

  create_table "quote_of_the_days", :force => true do |t|
    t.text     "content"
    t.string   "sourcedesc"
    t.string   "sourceurl"
    t.boolean  "published"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "quote_of_the_days", ["published"], :name => "index_quote_of_the_days_on_published"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "unreg_users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin",           :default => false
    t.boolean  "author",          :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
