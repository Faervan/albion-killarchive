# frozen_string_literal: true

class CreateAssists < ActiveRecord::Migration[7.1]
  def change
    create_table :assists do |t|
      t.references :player, null: false, foreign_key: true
      t.references :kill_event, null: false, foreign_key: true
      t.integer :average_item_power, limit: 2
      t.boolean :in_group_of_killer?
      t.integer :duo_rating_gain, limit: 2
    end
  end
end
