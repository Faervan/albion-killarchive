# frozen_string_literal: true

class CreatePassiveAssists < ActiveRecord::Migration[7.1]
  def change
    create_table :passive_assists do |t|
      t.integer :kill_event_id, null: false
      t.string :player_id, null: false
      t.string :main_hand_path
      t.string :awakened_weapon_id
      t.integer :kill_fame

      t.timestamps
    end
    add_foreign_key(
      :passive_assists,
      :kill_events,
      column: :kill_event_id,
      primary_key: :event_id
    )
    add_foreign_key(
      :passive_assists,
      :players,
      column: :player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :passive_assists,
      :main_hands,
      column: :main_hand_path,
      primary_key: :path
    )
    add_foreign_key(
      :passive_assists,
      :awakened_weapons,
      column: :awakened_weapon_id,
      primary_key: :awakened_weapon_id
    )
    add_index :passive_assists, :kill_event_id, unique: true
    add_index :passive_assists, :player_id
    add_index :passive_assists, :main_hand_path
  end
end
