# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :player_id, null: false
      t.string :name
      t.string :avatar_id
      t.string :avatar_ring_id
      t.string :guild_id
      t.integer :stalker_rating, limit: 2
      t.integer :slayer_rating, limit: 2
      t.integer :duo_rating, limit: 2
      t.integer :total_kill_fame
      t.integer :total_death_fame
      t.integer :total_kill_count, limit: 2
      t.integer :total_death_count, limit: 2

      t.timestamps
    end
    add_foreign_key(
      :players,
      :guilds,
      column: :guild_id,
      primary_key: :guild_id
    )
    add_foreign_key(
      :players,
      :avatars,
      column: :avatar_id,
      primary_key: :avatar_id
    )
    add_foreign_key(
      :players,
      :avatar_rings,
      column: :avatar_ring_id,
      primary_key: :avatar_ring_id
    )
    add_index :players, :player_id, unique: true
  end
end
