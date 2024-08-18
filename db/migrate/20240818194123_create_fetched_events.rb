# frozen_string_literal: true

class CreateFetchedEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :fetched_events do |t|
      t.integer :event_id, null: false
      t.time :expires_at
    end
    add_index :fetched_events, :event_id, unique: true
  end
end
