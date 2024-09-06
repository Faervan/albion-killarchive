# frozen_string_literal: true

class CreateGuilds < ActiveRecord::Migration[7.1]
  def change
    create_table :guilds do |t|
      t.string :guild_id, null: false
      t.string :name
      t.string :alliance_id
      t.integer :total_kill_fame, limit: 8
      t.integer :total_death_fame, limit: 8
      t.integer :total_kill_count
      t.integer :total_death_count
      t.integer :total_assist_count
      t.integer :kd_perc

      t.timestamps
    end
    add_foreign_key(
      :guilds,
      :alliances,
      column: :alliance_id,
      primary_key: :alliance_id
    )
    add_index :guilds, :guild_id, unique: true
    Guild.column_names.each do |name|
      name = name.to_sym
      add_index :guilds, name unless name == :id || name == :guild_id || name == :updated_at || name == :created_at
    end
  end
end
