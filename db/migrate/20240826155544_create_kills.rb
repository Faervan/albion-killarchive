# frozen_string_literal: true

class CreateKills < ActiveRecord::Migration[7.1]
  def change
    create_table :kills do |t|
      t.integer :kill_event_id, null: false
      t.string :player_id, null: false
      t.integer :build_id
      t.string :main_hand_path
      t.string :awakened_weapon_id
      t.string :off_hand_path
      t.string :head_path
      t.string :chest_path
      t.string :feet_path
      t.string :cape_path
      t.string :bag_path
      t.string :mount_path
      t.string :potion_path
      t.string :food_path
      t.integer :avg_ip
      t.integer :kill_fame
      t.integer :stalker_rating_gain
      t.integer :slayer_rating_gain
      t.integer :duo_rating_gain

      t.timestamps
    end
    add_foreign_key(
      :kills,
      :kill_events,
      column: :kill_event_id,
      primary_key: :event_id
    )
    add_foreign_key(
      :kills,
      :players,
      column: :player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :kills,
      :main_hands,
      column: :main_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :awakened_weapons,
      column: :awakened_weapon_id,
      primary_key: :awakened_weapon_id
    )
    add_foreign_key(
      :kills,
      :off_hands,
      column: :off_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :heads,
      column: :head_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :chests,
      column: :chest_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :feets,
      column: :feet_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :capes,
      column: :cape_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :bags,
      column: :bag_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :mounts,
      column: :mount_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :potions,
      column: :potion_path,
      primary_key: :path
    )
    add_foreign_key(
      :kills,
      :foods,
      column: :food_path,
      primary_key: :path
    )
    add_index :kills, :kill_event_id, unique: true
    add_index :kills, :player_id
    add_index :kills, :build_id
    add_index :kills, :main_hand_path
  end
end
