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

ActiveRecord::Schema.define(:version => 20140108054055) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["name", "state"], :name => "index_cities_on_name_and_state"

  create_table "restaurants", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "city_name"
    t.string   "state"
    t.string   "address"
    t.string   "secondary_name"
    t.string   "phone"
    t.string   "category"
    t.string   "labels"
    t.string   "description"
    t.string   "zip"
    t.integer  "rating"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "restaurants", ["city_name", "category", "rating"], :name => "index_restaurants_on_city_and_category_and_rating"
  add_index "restaurants", ["name"], :name => "index_restaurants_on_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username",                              :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "single_access_token",                   :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",            :default => 0, :null => false
    t.integer  "failed_login_count",     :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "weibo_access_token"
    t.string   "renren_access_token"
    t.string   "facebook_access_token"
    t.string   "instagram_access_token"
    t.string   "weibo_uid"
    t.string   "renren_uid"
    t.string   "facebook_uid"
    t.string   "instagram_uid"
  end

  add_index "users", ["weibo_access_token", "renren_access_token", "facebook_access_token", "instagram_access_token", "weibo_uid", "renren_uid", "facebook_uid", "instagram_uid", "email", "username"], :name => "users_index", :unique => true

end
