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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130623204515) do

  create_table "tweets", force: true do |t|
    t.integer  "followers"
    t.string   "remote_id"
    t.string   "message"
    t.float    "sentiment"
    t.string   "user_handle"
    t.datetime "remote_created_at"
    t.datetime "remote_updated_at"
    t.integer  "times_seen",        default: 0
  end

  add_index "tweets", ["remote_id"], name: "index_tweets_on_remote_id", unique: true, using: :btree
  add_index "tweets", ["user_handle"], name: "index_tweets_on_user_handle", using: :btree

end
