# frozen_string_literal: true

class CreateAlliances < ActiveRecord::Migration[7.1]
  def change
    create_table :alliances do |t|
      t.string :alliance_id, null: false
      t.string :name
      t.integer :total_kill_fame
      t.integer :total_death_fame
      t.integer :total_kill_count
      t.integer :total_death_count
      t.integer :total_assist_count
      t.integer :kd_perc

      t.timestamps
    end
    add_index :alliances, :alliance_id, unique: true
  end
end
