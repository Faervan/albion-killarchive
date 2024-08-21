# frozen_string_literal: true

class CreateFeets < ActiveRecord::Migration[7.1]
  def change
    create_table :feets do |t|
      t.string :path, null: false
      t.string :name
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :feets,
      :feet_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :feets, :path, unique: true
  end
end
