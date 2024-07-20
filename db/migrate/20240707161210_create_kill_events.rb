# frozen_string_literal: true

class CreateKillEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :kill_events do |t|
      t.integer :event_id, limit: 4, null: false
      t.integer :version, limit: 2
      t.datetime :time_stamp
      t.integer :total_victim_kill_fame, limit: 4
      t.integer :number_of_assists, limit: 2
      t.integer :number_of_allies, limit: 2

      t.timestamps
    end
  end
end
