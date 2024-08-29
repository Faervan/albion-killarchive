# frozen_string_literal: true

class CreateAwakenedWeapons < ActiveRecord::Migration[7.1]
  def change
    create_table :awakened_weapons do |t|
      t.string :awakened_weapon_id, null: false
      t.string :path, null: false
      t.string :item_type, null: false
      t.datetime :last_equipped_at
      t.string :attuned_player_id, null: false
      t.integer :attunement
      t.integer :attunement_since_reset
      t.string :crafted_player_id
      t.integer :pvp_fame
      t.string :trait0
      t.float :trait0_roll
      t.float :trait0_value
      t.string :trait1
      t.float :trait1_roll
      t.float :trait1_value
      t.string :trait2
      t.float :trait2_roll
      t.float :trait2_value

      t.timestamps
    end
    add_foreign_key(
      :awakened_weapons,
      :main_hands,
      column: :path,
      primary_key: :path
    )
    add_foreign_key(
      :awakened_weapons,
      :main_hand_types,
      column: :item_type,
      primary_key: :path
    )
    add_foreign_key(
      :awakened_weapons,
      :players,
      column: :attuned_player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :awakened_weapons,
      :players,
      column: :crafted_player_id,
      primary_key: :player_id
    )
    add_foreign_key(
      :awakened_weapons,
      :awakened_weapon_traits,
      column: :trait0,
      primary_key: :trait
    )
    add_foreign_key(
      :awakened_weapons,
      :awakened_weapon_traits,
      column: :trait1,
      primary_key: :trait
    )
    add_foreign_key(
      :awakened_weapons,
      :awakened_weapon_traits,
      column: :trait2,
      primary_key: :trait
    )
    add_index :awakened_weapons, :awakened_weapon_id, unique: true
    add_index :awakened_weapons, :item_type
    add_index :awakened_weapons, :last_equipped_at
    add_index :awakened_weapons, :attuned_player_id
    add_index :awakened_weapons, :attunement_since_reset
    add_index :awakened_weapons, :crafted_player_id
    add_index :awakened_weapons, :trait0
    add_index :awakened_weapons, :trait1
    add_index :awakened_weapons, :trait2
  end
end
