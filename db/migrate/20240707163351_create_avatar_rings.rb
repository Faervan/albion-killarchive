# frozen_string_literal: true

class CreateAvatarRings < ActiveRecord::Migration[7.1]
  def change
    create_table :avatar_rings do |t|
      t.string :avatar_ring_id, null: false
      t.string :name

      t.timestamps
    end
    add_index :avatar_rings, :avatar_ring_id, unique: true
  end
end
