# frozen_string_literal: true

class CreateDeaths < ActiveRecord::Migration[7.1]
  def change
    create_table :deaths do |t|
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
      t.integer :death_fame
      t.integer :stalker_rating_loss
      t.integer :slayer_rating_loss
      t.integer :duo_rating_loss

      t.timestamps
    end
    add_foreign_key(
      :deaths,
      :kill_events,
      column: :kill_event_id,
      primary_key: :event_id
    )
    add_foreign_key(
      :deaths,
      :players,
      column: :player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :deaths,
      :main_hands,
      column: :main_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :awakened_weapons,
      column: :awakened_weapon_id,
      primary_key: :awakened_weapon_id
    )
    add_foreign_key(
      :deaths,
      :off_hands,
      column: :off_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :heads,
      column: :head_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :chests,
      column: :chest_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :feets,
      column: :feet_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :capes,
      column: :cape_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :bags,
      column: :bag_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :mounts,
      column: :mount_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :potions,
      column: :potion_path,
      primary_key: :path
    )
    add_foreign_key(
      :deaths,
      :foods,
      column: :food_path,
      primary_key: :path
    )
    add_index :deaths, :kill_event_id, unique: true
    add_index :deaths, :player_id
    add_index :deaths, :build_id
    add_index :deaths, :main_hand_path
  end
end
