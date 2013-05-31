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

ActiveRecord::Schema.define(:version => 20130531123404) do

  create_table "chores", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "description"
    t.integer  "group_id",    :null => false
    t.integer  "user_id",     :null => false
    t.boolean  "completed"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "chores", ["group_id"], :name => "index_chores_on_group_id"
  add_index "chores", ["user_id"], :name => "index_chores_on_user_id"

  create_table "claims", :force => true do |t|
    t.string   "title",                                                                             :null => false
    t.string   "description",      :limit => 200
    t.decimal  "amount",                          :precision => 10, :scale => 2,                    :null => false
    t.boolean  "paid",                                                           :default => false, :null => false
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.integer  "user_owed_to_id",                                                                   :null => false
    t.integer  "user_who_owes_id",                                                                  :null => false
    t.datetime "paid_on"
  end

  add_index "claims", ["user_owed_to_id"], :name => "index_debts_on_user_owed_to_id"
  add_index "claims", ["user_who_owes_id"], :name => "index_debts_on_user_who_owes_id"

  create_table "comments", :force => true do |t|
    t.string   "content",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "claim_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["claim_id"], :name => "index_comments_on_debt_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "identifier", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["identifier"], :name => "index_groups_on_identifier"

  create_table "managers", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "name",         :null => false
    t.string   "phone_number", :null => false
    t.string   "address",      :null => false
    t.integer  "group_id",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "email"
  end

  add_index "managers", ["group_id"], :name => "index_managers_on_group_id"

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
    t.integer  "group_id",                               :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
