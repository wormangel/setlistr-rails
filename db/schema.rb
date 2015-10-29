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

ActiveRecord::Schema.define(version: 20151029195209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "bands", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "release"
    t.string   "genre"
    t.string   "logo"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "band_id"
    t.string   "instrument"
    t.datetime "date_joined"
    t.datetime "date_left"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "approved"
  end

  add_index "contracts", ["band_id"], name: "index_contracts_on_band_id", using: :btree
  add_index "contracts", ["user_id"], name: "index_contracts_on_user_id", using: :btree

  create_table "setlist_songs", force: :cascade do |t|
    t.integer  "song_id"
    t.integer  "setlist_id"
    t.integer  "pos"
    t.date     "date_added"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "setlist_songs", ["setlist_id"], name: "index_setlist_songs_on_setlist_id", using: :btree
  add_index "setlist_songs", ["song_id"], name: "index_setlist_songs_on_song_id", using: :btree

  create_table "setlists", force: :cascade do |t|
    t.integer  "band_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "master",     default: true
  end

  add_index "setlists", ["band_id"], name: "index_setlists_on_band_id", using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "artist"
    t.string   "title"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "oauth_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_foreign_key "setlist_songs", "setlists"
  add_foreign_key "setlist_songs", "songs"
  add_foreign_key "setlists", "bands"
end
