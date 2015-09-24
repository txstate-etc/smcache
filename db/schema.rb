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

ActiveRecord::Schema.define(version: 20150924000000) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "instagram_posts", force: :cascade do |t|
    t.string   "postid",       limit: 255,   null: false
    t.datetime "posttime",                   null: false
    t.binary   "caption",      limit: 65535
    t.text     "url",          limit: 65535
    t.integer  "width",        limit: 4
    t.integer  "height",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "mediatype",    limit: 255
    t.text     "video_url",    limit: 65535
    t.integer  "video_width",  limit: 4
    t.integer  "video_height", limit: 4
  end

  add_index "instagram_posts", ["postid"], name: "index_instagram_posts_on_postid", unique: true, using: :btree
  add_index "instagram_posts", ["posttime"], name: "index_instagram_posts_on_posttime", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string   "tweetid",       limit: 255
    t.datetime "tweettime"
    t.binary   "text",          limit: 65535
    t.string   "screen_name",   limit: 255
    t.binary   "display_name",  limit: 65535
    t.text     "profile_image", limit: 65535
    t.boolean  "favorite"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "tweets", ["tweetid"], name: "index_tweets_on_tweetid", unique: true, using: :btree
  add_index "tweets", ["tweettime", "favorite"], name: "tweets_time_fav", using: :btree
  add_index "tweets", ["tweettime"], name: "index_tweets_on_tweettime", using: :btree

  create_table "twitter_rate_limits", force: :cascade do |t|
    t.string   "endpoint",   limit: 255
    t.integer  "limit",      limit: 4
    t.integer  "remaining",  limit: 4
    t.datetime "reset_at"
    t.integer  "reset_in",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "twitter_rate_limits", ["endpoint"], name: "index_twitter_rate_limits_on_endpoint", unique: true, using: :btree

end
