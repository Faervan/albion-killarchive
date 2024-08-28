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

ActiveRecord::Schema[7.1].define(version: 2024_08_27_193130) do
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
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alliance_id"], name: "index_alliances_on_alliance_id", unique: true
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

  create_table "bag_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "usages"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_bag_types_on_path", unique: true
  end

  create_table "bags", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_bags_on_path", unique: true
  end

  create_table "cached_events", force: :cascade do |t|
    t.integer "event_id", null: false
    t.datetime "expires_at"
    t.index ["event_id"], name: "index_cached_events_on_event_id", unique: true
  end

  create_table "cape_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_cape_types_on_path", unique: true
  end

  create_table "capes", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_capes_on_path", unique: true
  end

  create_table "chest_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_chest_types_on_path", unique: true
  end

  create_table "chests", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_chests_on_path", unique: true
  end

  create_table "feet_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_feet_types_on_path", unique: true
  end

  create_table "feets", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_feets_on_path", unique: true
  end

  create_table "food_types", force: :cascade do |t|
    t.string "path", null: false
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_food_types_on_path", unique: true
  end

  create_table "foods", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_foods_on_path", unique: true
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
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "index_guilds_on_guild_id", unique: true
  end

  create_table "head_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_head_types_on_path", unique: true
  end

  create_table "heads", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_heads_on_path", unique: true
  end

  create_table "main_hand_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.boolean "two_handed?", default: false
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_main_hand_types_on_path", unique: true
  end

  create_table "main_hands", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_main_hands_on_path", unique: true
  end

  create_table "mount_types", force: :cascade do |t|
    t.string "path", null: false
    t.integer "usages"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_mount_types_on_path", unique: true
  end

  create_table "mounts", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_mounts_on_path", unique: true
  end

  create_table "off_hand_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_off_hand_types_on_path", unique: true
  end

  create_table "off_hands", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_off_hands_on_path", unique: true
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
    t.integer "kd_perc"
    t.integer "avg_ip"
    t.integer "total_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_players_on_player_id", unique: true
  end

  create_table "potion_types", force: :cascade do |t|
    t.string "path", null: false
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_potion_types_on_path", unique: true
  end

  create_table "potions", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "usages"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_potions_on_path", unique: true
  end

  add_foreign_key "bags", "bag_types", column: "item_type", primary_key: "path"
  add_foreign_key "capes", "cape_types", column: "item_type", primary_key: "path"
  add_foreign_key "chests", "chest_types", column: "item_type", primary_key: "path"
  add_foreign_key "feets", "feet_types", column: "item_type", primary_key: "path"
  add_foreign_key "foods", "food_types", column: "item_type", primary_key: "path"
  add_foreign_key "guilds", "alliances", primary_key: "alliance_id"
  add_foreign_key "heads", "head_types", column: "item_type", primary_key: "path"
  add_foreign_key "main_hands", "main_hand_types", column: "item_type", primary_key: "path"
  add_foreign_key "mounts", "mount_types", column: "item_type", primary_key: "path"
  add_foreign_key "off_hands", "off_hand_types", column: "item_type", primary_key: "path"
  add_foreign_key "players", "avatar_rings", primary_key: "avatar_ring_id"
  add_foreign_key "players", "avatars", primary_key: "avatar_id"
  add_foreign_key "players", "guilds", primary_key: "guild_id"
  add_foreign_key "potions", "potion_types", column: "item_type", primary_key: "path"
end
