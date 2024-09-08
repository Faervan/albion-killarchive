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

ActiveRecord::Schema[7.1].define(version: 2024_09_06_163630) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.string "alliance_id", null: false
    t.string "name"
    t.bigint "total_kill_fame"
    t.bigint "total_death_fame"
    t.integer "total_kill_count"
    t.integer "total_death_count"
    t.integer "total_assist_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alliance_id"], name: "index_alliances_on_alliance_id", unique: true
    t.index ["kd_perc"], name: "index_alliances_on_kd_perc"
    t.index ["name"], name: "index_alliances_on_name"
    t.index ["total_assist_count"], name: "index_alliances_on_total_assist_count"
    t.index ["total_death_count"], name: "index_alliances_on_total_death_count"
    t.index ["total_death_fame"], name: "index_alliances_on_total_death_fame"
    t.index ["total_kill_count"], name: "index_alliances_on_total_kill_count"
    t.index ["total_kill_fame"], name: "index_alliances_on_total_kill_fame"
  end

  create_table "assists", force: :cascade do |t|
    t.integer "kill_event_id", null: false
    t.string "player_id", null: false
    t.integer "build_id"
    t.string "main_hand_path"
    t.string "awakened_weapon_id"
    t.string "off_hand_path"
    t.string "head_path"
    t.string "chest_path"
    t.string "feet_path"
    t.string "cape_path"
    t.string "bag_path"
    t.string "mount_path"
    t.string "potion_path"
    t.string "food_path"
    t.integer "avg_ip"
    t.integer "kill_fame"
    t.integer "damage"
    t.integer "healing"
    t.boolean "ally?", null: false
    t.integer "duo_rating_gain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avg_ip"], name: "index_assists_on_avg_ip"
    t.index ["awakened_weapon_id"], name: "index_assists_on_awakened_weapon_id"
    t.index ["bag_path"], name: "index_assists_on_bag_path"
    t.index ["build_id"], name: "index_assists_on_build_id"
    t.index ["cape_path"], name: "index_assists_on_cape_path"
    t.index ["chest_path"], name: "index_assists_on_chest_path"
    t.index ["duo_rating_gain"], name: "index_assists_on_duo_rating_gain"
    t.index ["feet_path"], name: "index_assists_on_feet_path"
    t.index ["food_path"], name: "index_assists_on_food_path"
    t.index ["head_path"], name: "index_assists_on_head_path"
    t.index ["kill_event_id"], name: "index_assists_on_kill_event_id"
    t.index ["kill_fame"], name: "index_assists_on_kill_fame"
    t.index ["main_hand_path"], name: "index_assists_on_main_hand_path"
    t.index ["mount_path"], name: "index_assists_on_mount_path"
    t.index ["off_hand_path"], name: "index_assists_on_off_hand_path"
    t.index ["player_id"], name: "index_assists_on_player_id"
    t.index ["potion_path"], name: "index_assists_on_potion_path"
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

  create_table "awakened_weapon_traits", force: :cascade do |t|
    t.string "trait", null: false
    t.string "name"
    t.float "min_value"
    t.float "max_value"
    t.boolean "percentage?", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait"], name: "index_awakened_weapon_traits_on_trait", unique: true
  end

  create_table "awakened_weapons", force: :cascade do |t|
    t.string "awakened_weapon_id", null: false
    t.string "path", null: false
    t.string "item_type", null: false
    t.datetime "last_equipped_at"
    t.string "attuned_player_id", null: false
    t.bigint "attunement"
    t.bigint "attunement_since_reset"
    t.string "crafted_player_name"
    t.bigint "pvp_fame"
    t.string "trait0"
    t.float "trait0_roll"
    t.float "trait0_value"
    t.string "trait1"
    t.float "trait1_roll"
    t.float "trait1_value"
    t.string "trait2"
    t.float "trait2_roll"
    t.float "trait2_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attuned_player_id"], name: "index_awakened_weapons_on_attuned_player_id"
    t.index ["attunement"], name: "index_awakened_weapons_on_attunement"
    t.index ["attunement_since_reset"], name: "index_awakened_weapons_on_attunement_since_reset"
    t.index ["awakened_weapon_id"], name: "index_awakened_weapons_on_awakened_weapon_id", unique: true
    t.index ["crafted_player_name"], name: "index_awakened_weapons_on_crafted_player_name"
    t.index ["item_type"], name: "index_awakened_weapons_on_item_type"
    t.index ["last_equipped_at"], name: "index_awakened_weapons_on_last_equipped_at"
    t.index ["trait0"], name: "index_awakened_weapons_on_trait0"
    t.index ["trait1"], name: "index_awakened_weapons_on_trait1"
    t.index ["trait2"], name: "index_awakened_weapons_on_trait2"
  end

  create_table "bag_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "usage_count"
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

  create_table "builds", force: :cascade do |t|
    t.string "main_hand_type"
    t.string "off_hand_type"
    t.string "head_type"
    t.string "chest_type"
    t.string "feet_type"
    t.string "cape_type"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.bigint "kill_fame"
    t.bigint "death_fame"
    t.integer "fame_ratio"
    t.bigint "total_ip"
    t.integer "avg_ip"
    t.integer "total_ip_diff"
    t.integer "avg_ip_diff"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_builds_on_assist_count"
    t.index ["avg_ip"], name: "index_builds_on_avg_ip"
    t.index ["avg_ip_diff"], name: "index_builds_on_avg_ip_diff"
    t.index ["cape_type"], name: "index_builds_on_cape_type"
    t.index ["chest_type"], name: "index_builds_on_chest_type"
    t.index ["death_count"], name: "index_builds_on_death_count"
    t.index ["death_fame"], name: "index_builds_on_death_fame"
    t.index ["fame_ratio"], name: "index_builds_on_fame_ratio"
    t.index ["feet_type"], name: "index_builds_on_feet_type"
    t.index ["head_type"], name: "index_builds_on_head_type"
    t.index ["kd_perc"], name: "index_builds_on_kd_perc"
    t.index ["kill_count"], name: "index_builds_on_kill_count"
    t.index ["kill_fame"], name: "index_builds_on_kill_fame"
    t.index ["main_hand_type", "off_hand_type", "head_type", "chest_type", "feet_type", "cape_type"], name: "index_builds_on_unique_columns", unique: true
    t.index ["main_hand_type"], name: "index_builds_on_main_hand_type"
    t.index ["off_hand_type"], name: "index_builds_on_off_hand_type"
    t.index ["total_ip"], name: "index_builds_on_total_ip"
    t.index ["total_ip_diff"], name: "index_builds_on_total_ip_diff"
    t.index ["usage_count"], name: "index_builds_on_usage_count"
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
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_cape_types_on_assist_count"
    t.index ["avg_ip"], name: "index_cape_types_on_avg_ip"
    t.index ["death_count"], name: "index_cape_types_on_death_count"
    t.index ["kd_perc"], name: "index_cape_types_on_kd_perc"
    t.index ["kill_count"], name: "index_cape_types_on_kill_count"
    t.index ["name"], name: "index_cape_types_on_name"
    t.index ["path"], name: "index_cape_types_on_path", unique: true
    t.index ["usage_count"], name: "index_cape_types_on_usage_count"
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
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_chest_types_on_assist_count"
    t.index ["avg_ip"], name: "index_chest_types_on_avg_ip"
    t.index ["death_count"], name: "index_chest_types_on_death_count"
    t.index ["kd_perc"], name: "index_chest_types_on_kd_perc"
    t.index ["kill_count"], name: "index_chest_types_on_kill_count"
    t.index ["name"], name: "index_chest_types_on_name"
    t.index ["path"], name: "index_chest_types_on_path", unique: true
    t.index ["usage_count"], name: "index_chest_types_on_usage_count"
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

  create_table "deaths", force: :cascade do |t|
    t.integer "kill_event_id", null: false
    t.string "player_id", null: false
    t.integer "build_id"
    t.string "main_hand_path"
    t.string "awakened_weapon_id"
    t.string "off_hand_path"
    t.string "head_path"
    t.string "chest_path"
    t.string "feet_path"
    t.string "cape_path"
    t.string "bag_path"
    t.string "mount_path"
    t.string "potion_path"
    t.string "food_path"
    t.integer "avg_ip"
    t.integer "death_fame"
    t.integer "stalker_rating_loss"
    t.integer "slayer_rating_loss"
    t.integer "duo_rating_loss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avg_ip"], name: "index_deaths_on_avg_ip"
    t.index ["awakened_weapon_id"], name: "index_deaths_on_awakened_weapon_id"
    t.index ["bag_path"], name: "index_deaths_on_bag_path"
    t.index ["build_id"], name: "index_deaths_on_build_id"
    t.index ["cape_path"], name: "index_deaths_on_cape_path"
    t.index ["chest_path"], name: "index_deaths_on_chest_path"
    t.index ["death_fame"], name: "index_deaths_on_death_fame"
    t.index ["duo_rating_loss"], name: "index_deaths_on_duo_rating_loss"
    t.index ["feet_path"], name: "index_deaths_on_feet_path"
    t.index ["food_path"], name: "index_deaths_on_food_path"
    t.index ["head_path"], name: "index_deaths_on_head_path"
    t.index ["kill_event_id"], name: "index_deaths_on_kill_event_id", unique: true
    t.index ["main_hand_path"], name: "index_deaths_on_main_hand_path"
    t.index ["mount_path"], name: "index_deaths_on_mount_path"
    t.index ["off_hand_path"], name: "index_deaths_on_off_hand_path"
    t.index ["player_id"], name: "index_deaths_on_player_id"
    t.index ["potion_path"], name: "index_deaths_on_potion_path"
    t.index ["slayer_rating_loss"], name: "index_deaths_on_slayer_rating_loss"
    t.index ["stalker_rating_loss"], name: "index_deaths_on_stalker_rating_loss"
  end

  create_table "feet_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_feet_types_on_assist_count"
    t.index ["avg_ip"], name: "index_feet_types_on_avg_ip"
    t.index ["death_count"], name: "index_feet_types_on_death_count"
    t.index ["kd_perc"], name: "index_feet_types_on_kd_perc"
    t.index ["kill_count"], name: "index_feet_types_on_kill_count"
    t.index ["name"], name: "index_feet_types_on_name"
    t.index ["path"], name: "index_feet_types_on_path", unique: true
    t.index ["usage_count"], name: "index_feet_types_on_usage_count"
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
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_food_types_on_assist_count"
    t.index ["avg_ip"], name: "index_food_types_on_avg_ip"
    t.index ["death_count"], name: "index_food_types_on_death_count"
    t.index ["kd_perc"], name: "index_food_types_on_kd_perc"
    t.index ["kill_count"], name: "index_food_types_on_kill_count"
    t.index ["path"], name: "index_food_types_on_path", unique: true
    t.index ["usage_count"], name: "index_food_types_on_usage_count"
  end

  create_table "foods", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_foods_on_assist_count"
    t.index ["avg_ip"], name: "index_foods_on_avg_ip"
    t.index ["death_count"], name: "index_foods_on_death_count"
    t.index ["kd_perc"], name: "index_foods_on_kd_perc"
    t.index ["kill_count"], name: "index_foods_on_kill_count"
    t.index ["name"], name: "index_foods_on_name"
    t.index ["path"], name: "index_foods_on_path", unique: true
    t.index ["usage_count"], name: "index_foods_on_usage_count"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "guild_id", null: false
    t.string "name"
    t.string "alliance_id"
    t.bigint "total_kill_fame"
    t.bigint "total_death_fame"
    t.integer "total_kill_count"
    t.integer "total_death_count"
    t.integer "total_assist_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alliance_id"], name: "index_guilds_on_alliance_id"
    t.index ["guild_id"], name: "index_guilds_on_guild_id", unique: true
    t.index ["kd_perc"], name: "index_guilds_on_kd_perc"
    t.index ["name"], name: "index_guilds_on_name"
    t.index ["total_assist_count"], name: "index_guilds_on_total_assist_count"
    t.index ["total_death_count"], name: "index_guilds_on_total_death_count"
    t.index ["total_death_fame"], name: "index_guilds_on_total_death_fame"
    t.index ["total_kill_count"], name: "index_guilds_on_total_kill_count"
    t.index ["total_kill_fame"], name: "index_guilds_on_total_kill_fame"
  end

  create_table "head_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_head_types_on_assist_count"
    t.index ["avg_ip"], name: "index_head_types_on_avg_ip"
    t.index ["death_count"], name: "index_head_types_on_death_count"
    t.index ["kd_perc"], name: "index_head_types_on_kd_perc"
    t.index ["kill_count"], name: "index_head_types_on_kill_count"
    t.index ["name"], name: "index_head_types_on_name"
    t.index ["path"], name: "index_head_types_on_path", unique: true
    t.index ["usage_count"], name: "index_head_types_on_usage_count"
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

  create_table "kill_events", force: :cascade do |t|
    t.integer "kill_event_id", null: false
    t.datetime "timestamp"
    t.integer "total_fame"
    t.integer "assist_count"
    t.integer "ally_count"
    t.integer "passive_assist_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ally_count"], name: "index_kill_events_on_ally_count"
    t.index ["assist_count"], name: "index_kill_events_on_assist_count"
    t.index ["kill_event_id"], name: "index_kill_events_on_kill_event_id", unique: true
    t.index ["passive_assist_count"], name: "index_kill_events_on_passive_assist_count"
    t.index ["timestamp"], name: "index_kill_events_on_timestamp"
    t.index ["total_fame"], name: "index_kill_events_on_total_fame"
  end

  create_table "kills", force: :cascade do |t|
    t.integer "kill_event_id", null: false
    t.string "player_id", null: false
    t.integer "build_id", null: false
    t.string "main_hand_path"
    t.string "awakened_weapon_id"
    t.string "off_hand_path"
    t.string "head_path"
    t.string "chest_path"
    t.string "feet_path"
    t.string "cape_path"
    t.string "bag_path"
    t.string "mount_path"
    t.string "potion_path"
    t.string "food_path"
    t.integer "avg_ip"
    t.integer "kill_fame"
    t.integer "stalker_rating_gain"
    t.integer "slayer_rating_gain"
    t.integer "duo_rating_gain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avg_ip"], name: "index_kills_on_avg_ip"
    t.index ["awakened_weapon_id"], name: "index_kills_on_awakened_weapon_id"
    t.index ["bag_path"], name: "index_kills_on_bag_path"
    t.index ["build_id"], name: "index_kills_on_build_id"
    t.index ["cape_path"], name: "index_kills_on_cape_path"
    t.index ["chest_path"], name: "index_kills_on_chest_path"
    t.index ["duo_rating_gain"], name: "index_kills_on_duo_rating_gain"
    t.index ["feet_path"], name: "index_kills_on_feet_path"
    t.index ["food_path"], name: "index_kills_on_food_path"
    t.index ["head_path"], name: "index_kills_on_head_path"
    t.index ["kill_event_id"], name: "index_kills_on_kill_event_id", unique: true
    t.index ["kill_fame"], name: "index_kills_on_kill_fame"
    t.index ["main_hand_path"], name: "index_kills_on_main_hand_path"
    t.index ["mount_path"], name: "index_kills_on_mount_path"
    t.index ["off_hand_path"], name: "index_kills_on_off_hand_path"
    t.index ["player_id"], name: "index_kills_on_player_id"
    t.index ["potion_path"], name: "index_kills_on_potion_path"
    t.index ["slayer_rating_gain"], name: "index_kills_on_slayer_rating_gain"
    t.index ["stalker_rating_gain"], name: "index_kills_on_stalker_rating_gain"
  end

  create_table "main_hand_types", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.boolean "two_handed?", default: false
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_main_hand_types_on_assist_count"
    t.index ["avg_ip"], name: "index_main_hand_types_on_avg_ip"
    t.index ["death_count"], name: "index_main_hand_types_on_death_count"
    t.index ["kd_perc"], name: "index_main_hand_types_on_kd_perc"
    t.index ["kill_count"], name: "index_main_hand_types_on_kill_count"
    t.index ["name"], name: "index_main_hand_types_on_name"
    t.index ["path"], name: "index_main_hand_types_on_path", unique: true
    t.index ["two_handed?"], name: "index_main_hand_types_on_two_handed?"
    t.index ["usage_count"], name: "index_main_hand_types_on_usage_count"
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
    t.integer "usage_count"
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
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.integer "base_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_off_hand_types_on_assist_count"
    t.index ["avg_ip"], name: "index_off_hand_types_on_avg_ip"
    t.index ["death_count"], name: "index_off_hand_types_on_death_count"
    t.index ["kd_perc"], name: "index_off_hand_types_on_kd_perc"
    t.index ["kill_count"], name: "index_off_hand_types_on_kill_count"
    t.index ["name"], name: "index_off_hand_types_on_name"
    t.index ["path"], name: "index_off_hand_types_on_path", unique: true
    t.index ["usage_count"], name: "index_off_hand_types_on_usage_count"
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

  create_table "passive_assists", force: :cascade do |t|
    t.integer "kill_event_id", null: false
    t.string "player_id", null: false
    t.string "main_hand_path"
    t.string "awakened_weapon_id"
    t.integer "kill_fame"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awakened_weapon_id"], name: "index_passive_assists_on_awakened_weapon_id"
    t.index ["kill_event_id"], name: "index_passive_assists_on_kill_event_id"
    t.index ["kill_fame"], name: "index_passive_assists_on_kill_fame"
    t.index ["main_hand_path"], name: "index_passive_assists_on_main_hand_path"
    t.index ["player_id"], name: "index_passive_assists_on_player_id"
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
    t.bigint "total_kill_fame"
    t.bigint "total_death_fame"
    t.integer "total_kill_count"
    t.integer "total_death_count"
    t.integer "total_assist_count"
    t.integer "kd_perc"
    t.integer "avg_ip"
    t.integer "total_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avg_ip"], name: "index_players_on_avg_ip"
    t.index ["duo_rating"], name: "index_players_on_duo_rating"
    t.index ["guild_id"], name: "index_players_on_guild_id"
    t.index ["kd_perc"], name: "index_players_on_kd_perc"
    t.index ["name"], name: "index_players_on_name"
    t.index ["player_id"], name: "index_players_on_player_id", unique: true
    t.index ["slayer_rating"], name: "index_players_on_slayer_rating"
    t.index ["stalker_rating"], name: "index_players_on_stalker_rating"
    t.index ["total_assist_count"], name: "index_players_on_total_assist_count"
    t.index ["total_death_count"], name: "index_players_on_total_death_count"
    t.index ["total_death_fame"], name: "index_players_on_total_death_fame"
    t.index ["total_kill_count"], name: "index_players_on_total_kill_count"
    t.index ["total_kill_fame"], name: "index_players_on_total_kill_fame"
  end

  create_table "potion_types", force: :cascade do |t|
    t.string "path", null: false
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_potion_types_on_assist_count"
    t.index ["avg_ip"], name: "index_potion_types_on_avg_ip"
    t.index ["death_count"], name: "index_potion_types_on_death_count"
    t.index ["kd_perc"], name: "index_potion_types_on_kd_perc"
    t.index ["kill_count"], name: "index_potion_types_on_kill_count"
    t.index ["path"], name: "index_potion_types_on_path", unique: true
    t.index ["usage_count"], name: "index_potion_types_on_usage_count"
  end

  create_table "potions", force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "item_type", null: false
    t.integer "tier"
    t.integer "enchantment"
    t.integer "total_ip"
    t.integer "avg_ip"
    t.integer "kill_count"
    t.integer "death_count"
    t.integer "assist_count"
    t.integer "usage_count"
    t.integer "kd_perc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assist_count"], name: "index_potions_on_assist_count"
    t.index ["avg_ip"], name: "index_potions_on_avg_ip"
    t.index ["death_count"], name: "index_potions_on_death_count"
    t.index ["kd_perc"], name: "index_potions_on_kd_perc"
    t.index ["kill_count"], name: "index_potions_on_kill_count"
    t.index ["name"], name: "index_potions_on_name"
    t.index ["path"], name: "index_potions_on_path", unique: true
    t.index ["usage_count"], name: "index_potions_on_usage_count"
  end

  add_foreign_key "assists", "awakened_weapons", primary_key: "awakened_weapon_id"
  add_foreign_key "assists", "bags", column: "bag_path", primary_key: "path"
  add_foreign_key "assists", "builds"
  add_foreign_key "assists", "capes", column: "cape_path", primary_key: "path"
  add_foreign_key "assists", "chests", column: "chest_path", primary_key: "path"
  add_foreign_key "assists", "feets", column: "feet_path", primary_key: "path"
  add_foreign_key "assists", "foods", column: "food_path", primary_key: "path"
  add_foreign_key "assists", "heads", column: "head_path", primary_key: "path"
  add_foreign_key "assists", "kill_events", primary_key: "kill_event_id"
  add_foreign_key "assists", "main_hands", column: "main_hand_path", primary_key: "path"
  add_foreign_key "assists", "mounts", column: "mount_path", primary_key: "path"
  add_foreign_key "assists", "off_hands", column: "off_hand_path", primary_key: "path"
  add_foreign_key "assists", "players", primary_key: "player_id"
  add_foreign_key "assists", "potions", column: "potion_path", primary_key: "path"
  add_foreign_key "awakened_weapons", "awakened_weapon_traits", column: "trait0", primary_key: "trait"
  add_foreign_key "awakened_weapons", "awakened_weapon_traits", column: "trait1", primary_key: "trait"
  add_foreign_key "awakened_weapons", "awakened_weapon_traits", column: "trait2", primary_key: "trait"
  add_foreign_key "awakened_weapons", "main_hand_types", column: "item_type", primary_key: "path"
  add_foreign_key "awakened_weapons", "main_hands", column: "path", primary_key: "path"
  add_foreign_key "awakened_weapons", "players", column: "attuned_player_id", primary_key: "player_id"
  add_foreign_key "bags", "bag_types", column: "item_type", primary_key: "path"
  add_foreign_key "builds", "cape_types", column: "cape_type", primary_key: "path"
  add_foreign_key "builds", "chest_types", column: "chest_type", primary_key: "path"
  add_foreign_key "builds", "feet_types", column: "feet_type", primary_key: "path"
  add_foreign_key "builds", "head_types", column: "head_type", primary_key: "path"
  add_foreign_key "builds", "main_hand_types", column: "main_hand_type", primary_key: "path"
  add_foreign_key "builds", "off_hand_types", column: "off_hand_type", primary_key: "path"
  add_foreign_key "capes", "cape_types", column: "item_type", primary_key: "path"
  add_foreign_key "chests", "chest_types", column: "item_type", primary_key: "path"
  add_foreign_key "deaths", "awakened_weapons", primary_key: "awakened_weapon_id"
  add_foreign_key "deaths", "bags", column: "bag_path", primary_key: "path"
  add_foreign_key "deaths", "builds"
  add_foreign_key "deaths", "capes", column: "cape_path", primary_key: "path"
  add_foreign_key "deaths", "chests", column: "chest_path", primary_key: "path"
  add_foreign_key "deaths", "feets", column: "feet_path", primary_key: "path"
  add_foreign_key "deaths", "foods", column: "food_path", primary_key: "path"
  add_foreign_key "deaths", "heads", column: "head_path", primary_key: "path"
  add_foreign_key "deaths", "kill_events", primary_key: "kill_event_id"
  add_foreign_key "deaths", "main_hands", column: "main_hand_path", primary_key: "path"
  add_foreign_key "deaths", "mounts", column: "mount_path", primary_key: "path"
  add_foreign_key "deaths", "off_hands", column: "off_hand_path", primary_key: "path"
  add_foreign_key "deaths", "players", primary_key: "player_id"
  add_foreign_key "deaths", "potions", column: "potion_path", primary_key: "path"
  add_foreign_key "feets", "feet_types", column: "item_type", primary_key: "path"
  add_foreign_key "foods", "food_types", column: "item_type", primary_key: "path"
  add_foreign_key "guilds", "alliances", primary_key: "alliance_id"
  add_foreign_key "heads", "head_types", column: "item_type", primary_key: "path"
  add_foreign_key "kills", "awakened_weapons", primary_key: "awakened_weapon_id"
  add_foreign_key "kills", "bags", column: "bag_path", primary_key: "path"
  add_foreign_key "kills", "builds"
  add_foreign_key "kills", "capes", column: "cape_path", primary_key: "path"
  add_foreign_key "kills", "chests", column: "chest_path", primary_key: "path"
  add_foreign_key "kills", "feets", column: "feet_path", primary_key: "path"
  add_foreign_key "kills", "foods", column: "food_path", primary_key: "path"
  add_foreign_key "kills", "heads", column: "head_path", primary_key: "path"
  add_foreign_key "kills", "kill_events", primary_key: "kill_event_id"
  add_foreign_key "kills", "main_hands", column: "main_hand_path", primary_key: "path"
  add_foreign_key "kills", "mounts", column: "mount_path", primary_key: "path"
  add_foreign_key "kills", "off_hands", column: "off_hand_path", primary_key: "path"
  add_foreign_key "kills", "players", primary_key: "player_id"
  add_foreign_key "kills", "potions", column: "potion_path", primary_key: "path"
  add_foreign_key "main_hands", "main_hand_types", column: "item_type", primary_key: "path"
  add_foreign_key "mounts", "mount_types", column: "item_type", primary_key: "path"
  add_foreign_key "off_hands", "off_hand_types", column: "item_type", primary_key: "path"
  add_foreign_key "passive_assists", "awakened_weapons", primary_key: "awakened_weapon_id"
  add_foreign_key "passive_assists", "kill_events", primary_key: "kill_event_id"
  add_foreign_key "passive_assists", "main_hands", column: "main_hand_path", primary_key: "path"
  add_foreign_key "passive_assists", "players", primary_key: "player_id"
  add_foreign_key "players", "avatar_rings", primary_key: "avatar_ring_id"
  add_foreign_key "players", "avatars", primary_key: "avatar_id"
  add_foreign_key "players", "guilds", primary_key: "guild_id"
  add_foreign_key "potions", "potion_types", column: "item_type", primary_key: "path"
end
