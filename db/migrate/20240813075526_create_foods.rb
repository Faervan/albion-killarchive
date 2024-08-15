# frozen_string_literal: true

class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.string :path, null: false
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :avg_ip
      t.integer :kills
      t.integer :deaths
      t.integer :assists

      t.timestamps
    end
    add_foreign_key(
      :foods,
      :food_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :foods, :path, unique: true
  end
end
