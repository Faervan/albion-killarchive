# frozen_string_literal: true

class CreateMainHands < ActiveRecord::Migration[7.1]
  def change
    create_table :main_hands do |t|
      t.string :path, null: false
      t.string :name
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :main_hands,
      :main_hand_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :main_hands, :path, unique: true
  end
end
