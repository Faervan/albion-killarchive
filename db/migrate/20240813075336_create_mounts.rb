# frozen_string_literal: true

class CreateMounts < ActiveRecord::Migration[7.1]
  def change
    create_table :mounts do |t|
      t.string :path, null: false
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :quality

      t.timestamps
    end
    add_foreign_key(
      :mounts,
      :mount_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :mounts, :path, unique: true
  end
end
