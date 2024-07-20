# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :player_id, null: false
      t.string :name
      t.references :avatar, null: false, foreign_key: true
      t.references :avatar_ring, null: false, foreign_key: true
      t.references :guild, null: true, foreign_key: true
      t.integer :stalker_rating, limit: 2
      t.integer :slayer_rating, limit: 2
      t.integer :duo_rating, limit: 2
      t.integer :total_kill_fame
      t.integer :total_death_fame
      t.integer :total_kill_count, limit: 2
      t.integer :total_death_count, limit: 2

      t.timestamps
    end
  end
end
