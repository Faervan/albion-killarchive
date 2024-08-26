# frozen_string_literal: true

class CreateAssists < ActiveRecord::Migration[7.1]
  def change
    create_table :assists do |t|
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
      t.integer :damage
      t.integer :healing
      t.integer :duo_rating_gain

      t.timestamps
    end
    add_foreign_key(
      :assists,
      :kill_events,
      column: :kill_event_id,
      primary_key: :event_id
    )
    add_foreign_key(
      :assists,
      :players,
      column: :player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :assists,
      :main_hands,
      column: :main_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :awakened_weapons,
      column: :awakened_weapon_id,
      primary_key: :awakened_weapon_id
    )
    add_foreign_key(
      :assists,
      :off_hands,
      column: :off_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :heads,
      column: :head_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :chests,
      column: :chest_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :feets,
      column: :feet_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :capes,
      column: :cape_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :bags,
      column: :bag_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :mounts,
      column: :mount_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :potions,
      column: :potion_path,
      primary_key: :path
    )
    add_foreign_key(
      :assists,
      :foods,
      column: :food_path,
      primary_key: :path
    )
    add_index :assists, :kill_event_id, unique: true
    add_index :assists, :player_id
    add_index :assists, :build_id
    add_index :assists, :main_hand_path
  end
end
