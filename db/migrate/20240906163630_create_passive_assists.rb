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
    %I[kill_event_id player_id awakened_weapon_id].each do |id|
      add_foreign_key(
        :passive_assists,
        id.to_s.sub(/_id/, 's').to_sym,
        column: id,
        primary_key: id
      )
    end
    add_foreign_key(
      :passive_assists,
      :main_hands,
      column: :main_hand_path,
      primary_key: :path
    )
    add_index :passive_assists, :kill_event_id
    add_index :passive_assists, :player_id
    add_index :passive_assists, :main_hand_path
    add_index :passive_assists, :awakened_weapon_id
    add_index :passive_assists, :kill_fame
  end
end
