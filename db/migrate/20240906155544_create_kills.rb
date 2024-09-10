# frozen_string_literal: true

class CreateKills < ActiveRecord::Migration[7.1]
  def change
    create_table :kills do |t|
      t.integer :kill_event_id, null: false
      t.string :player_id, null: false
      t.integer :build_id, null: false
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
      t.integer :damage
      t.integer :healing
      t.integer :stalker_rating_gain
      t.integer :slayer_rating_gain
      t.integer :duo_rating_gain

      t.timestamps
    end
    add_index :kills, :kill_event_id, unique: true
    %I[player_id build_id main_hand_path awakened_weapon_id off_hand_path head_path chest_path feet_path cape_path bag_path
    mount_path potion_path food_path avg_ip kill_fame damage healing stalker_rating_gain slayer_rating_gain duo_rating_gain].each do |col|
      add_index :kills, col
    end
    %I[main_hand_path off_hand_path head_path chest_path feet_path cape_path bag_path mount_path potion_path food_path].each do |type|
      add_foreign_key(
        :kills,
        type.to_s.sub(/_path/, 's').to_sym,
        column: type,
        primary_key: :path
      )
    end
    %I[kill_event_id player_id build_id awakened_weapon_id].each do |id|
      add_foreign_key(
        :kills,
        id.to_s.sub(/_id/, 's').to_sym,
        column: id,
        primary_key: id == :build_id ? :id : id
      )
    end
  end
end
