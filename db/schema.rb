# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_07_170743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.string "alliance_id", null: false
    t.string "name"
    t.integer "total_kill_fame"
    t.integer "total_death_fame"
    t.integer "total_kill_count"
    t.integer "total_death_count"
    t.integer "total_assist_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alliance_id"], name: "index_alliances_on_alliance_id", unique: true
  end

  create_table "assists", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "kill_event_id", null: false
    t.integer "average_item_power", limit: 2
    t.boolean "in_group_of_killer?"
    t.integer "duo_rating_gain", limit: 2
    t.index ["kill_event_id"], name: "index_assists_on_kill_event_id"
    t.index ["player_id"], name: "index_assists_on_player_id"
  end

  create_table "avatar_rings", force: :cascade do |t|
    t.string "avatar_ring_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_ring_id"], name: "index_avatar_rings_on_avatar_ring_id", unique: true
  end

  create_table "avatars", force: :cascade do |t|
    t.string "avatar_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_id"], name: "index_avatars_on_avatar_id", unique: true
  end

  create_table "deaths", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "kill_event_id", null: false
    t.integer "average_item_power", limit: 2
    t.integer "stalker_rating_loss", limit: 2
    t.integer "slayer_rating_loss", limit: 2
    t.integer "duo_rating_loss", limit: 2
    t.index ["kill_event_id"], name: "index_deaths_on_kill_event_id"
    t.index ["player_id"], name: "index_deaths_on_player_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "guild_id", null: false
    t.string "name"
    t.string "alliance_id"
    t.integer "total_kill_fame"
    t.integer "total_death_fame"
    t.integer "total_kill_count"
    t.integer "total_death_count"
    t.integer "total_assist_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "index_guilds_on_guild_id", unique: true
  end

  create_table "kill_events", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "version", limit: 2
    t.datetime "time_stamp"
    t.integer "total_victim_kill_fame"
    t.integer "number_of_assists", limit: 2
    t.integer "number_of_allies", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kills", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "kill_event_id", null: false
    t.integer "average_item_power", limit: 2
    t.integer "stalker_rating_gain", limit: 2
    t.integer "slayer_rating_gain", limit: 2
    t.integer "duo_rating_gain", limit: 2
    t.index ["kill_event_id"], name: "index_kills_on_kill_event_id"
    t.index ["player_id"], name: "index_kills_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_id", null: false
    t.string "name"
    t.string "avatar_id"
    t.string "avatar_ring_id"
    t.string "guild_id"
    t.integer "stalker_rating", limit: 2
    t.integer "slayer_rating", limit: 2
    t.integer "duo_rating", limit: 2
    t.integer "total_kill_fame"
    t.integer "total_death_fame"
    t.integer "total_kill_count", limit: 2
    t.integer "total_death_count", limit: 2
    t.integer "total_assist_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_players_on_player_id", unique: true
  end

  add_foreign_key "assists", "kill_events"
  add_foreign_key "assists", "players"
  add_foreign_key "deaths", "kill_events"
  add_foreign_key "deaths", "players"
  add_foreign_key "guilds", "alliances", primary_key: "alliance_id"
  add_foreign_key "kills", "kill_events"
  add_foreign_key "kills", "players"
  add_foreign_key "players", "avatar_rings", primary_key: "avatar_ring_id"
  add_foreign_key "players", "avatars", primary_key: "avatar_id"
  add_foreign_key "players", "guilds", primary_key: "guild_id"
end
