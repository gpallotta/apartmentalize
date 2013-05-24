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

ActiveRecord::Schema.define(:version => 20130524130157) do

  create_table "comments", :force => true do |t|
    t.string   "content",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "debt_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["debt_id"], :name => "index_comments_on_debt_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "debts", :force => true do |t|
    t.string   "title",                                                                             :null => false
    t.string   "description",      :limit => 200
    t.decimal  "amount",                          :precision => 10, :scale => 2,                    :null => false
    t.boolean  "paid",                                                           :default => false, :null => false
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.integer  "user_owed_to_id",                                                                   :null => false
    t.integer  "user_who_owes_id",                                                                  :null => false
  end

  add_index "debts", ["user_owed_to_id"], :name => "index_debts_on_user_owed_to_id"
  add_index "debts", ["user_who_owes_id"], :name => "index_debts_on_user_who_owes_id"

  create_table "groups", :force => true do |t|
    t.string   "identifier", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["identifier"], :name => "index_groups_on_identifier"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name",                                   :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
