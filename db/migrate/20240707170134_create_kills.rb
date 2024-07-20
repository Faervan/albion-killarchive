# frozen_string_literal: true

class CreateKills < ActiveRecord::Migration[7.1]
  def change
    create_table :kills do |t|
      t.references :player, null: false, foreign_key: true
      t.references :kill_event, null: false, foreign_key: true
      t.integer :average_item_power, limit: 2
      t.integer :stalker_rating_gain, limit: 2
      t.integer :slayer_rating_gain, limit: 2
      t.integer :duo_rating_gain, limit: 2
    end
  end
end
