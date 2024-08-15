# frozen_string_literal: true

class CreateOffHands < ActiveRecord::Migration[7.1]
  def change
    create_table :off_hands do |t|
      t.string :path, null: false
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :off_hands,
      :off_hand_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :off_hands, :path, unique: true
  end
end
