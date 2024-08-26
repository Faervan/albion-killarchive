# frozen_string_literal: true

class CreateKillEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :kill_events do |t|
      t.integer :event_id, null: false
      t.datetime :timestamp
      t.integer :kill_fame
      t.integer :assists
      t.integer :allies
      t.string :killer_id
      t.string :victim_id

      t.timestamps
    end
    add_index :kill_events, :event_id, unique: true
  end
end
