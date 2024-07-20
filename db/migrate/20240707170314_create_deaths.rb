# frozen_string_literal: true

class CreateDeaths < ActiveRecord::Migration[7.1]
  def change
    create_table :deaths do |t|
      t.references :player, null: false, foreign_key: true
      t.references :kill_event, null: false, foreign_key: true
      t.integer :average_item_power, limit: 2
      t.integer :stalker_rating_loss, limit: 2
      t.integer :slayer_rating_loss, limit: 2
      t.integer :duo_rating_loss, limit: 2
    end
  end
end
