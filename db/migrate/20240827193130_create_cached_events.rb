# frozen_string_literal: true

class CreateCachedEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :cached_events do |t|
      t.integer :event_id, null: false
      t.datetime :expires_at
    end
    add_index :cached_events, :event_id, unique: true
  end
end
