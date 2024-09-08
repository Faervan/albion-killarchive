# frozen_string_literal: true

class CreateKillEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :kill_events do |t|
      t.integer :kill_event_id, null: false
      t.datetime :timestamp
      t.integer :total_fame
      t.integer :assists
      t.integer :allies
      t.integer :passive_assists

      t.timestamps
    end
    add_index :kill_events, :kill_event_id, unique: true
    %I[timestamp total_fame assists allies passive_assists].each do |name|
      add_index :kill_events, name
    end
  end
end
