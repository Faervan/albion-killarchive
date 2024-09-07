# frozen_string_literal: true

class CreateKillEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :kill_events do |t|
      t.integer :kill_event_id, null: false
      t.datetime :timestamp
      t.integer :kill_fame
      t.integer :assists
      t.integer :allies

      t.timestamps
    end
    add_index :kill_events, :kill_event_id, unique: true
    [:timestamp, :kill_fame, :assists, :allies].each do |name|
      add_index :kill_events, name
    end
  end
end
