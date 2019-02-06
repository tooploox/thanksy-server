# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_204_121_619) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "slack_users", id: false, force: :cascade do |t|
    t.string "id"
    t.string "name"
    t.string "real_name"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "thanks_sent", default: 0
    t.integer "thanks_recived", default: 0
    t.index ["id"], name: "index_slack_users_on_id"
    t.index ["name"], name: "index_slack_users_on_name"
  end

  create_table "thanks", force: :cascade do |t|
    t.jsonb "giver", default: {}
    t.jsonb "receivers", default: {}
    t.integer "love_count", default: 0
    t.integer "confetti_count", default: 0
    t.integer "clap_count", default: 0
    t.integer "wow_count", default: 0
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "popularity", default: 0
  end
end
