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
    add_index :deaths, :kill_event_id, unique: true
    %I[player_id build_id main_hand_path awakened_weapon_id off_hand_path head_path chest_path feet_path cape_path bag_path
    mount_path potion_path food_path avg_ip death_fame stalker_rating_loss slayer_rating_loss duo_rating_loss].each do |col|
      add_index :deaths, col
    end
    %I[main_hand_path off_hand_path head_path chest_path feet_path cape_path bag_path mount_path potion_path food_path].each do |type|
      add_foreign_key(
        :deaths,
        type.to_s.sub(/_path/, 's').to_sym,
        column: type,
        primary_key: :path
      )
    end
    %I[kill_event_id player_id build_id awakened_weapon_id].each do |id|
      add_foreign_key(
        :deaths,
        id.to_s.sub(/_id/, 's').to_sym,
        column: id,
        primary_key: id == :build_id ? :id : id
      )
    end
  end
end
