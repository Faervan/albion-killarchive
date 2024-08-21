# frozen_string_literal: true

class CreateCapes < ActiveRecord::Migration[7.1]
  def change
    create_table :capes do |t|
      t.string :path, null: false
      t.string :name
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :capes,
      :cape_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :capes, :path, unique: true
  end
end
