# frozen_string_literal: true

class CreateHeads < ActiveRecord::Migration[7.1]
  def change
    create_table :heads do |t|
      t.string :path, null: false
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :heads,
      :head_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :heads, :path, unique: true
  end
end
