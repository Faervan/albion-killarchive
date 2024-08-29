# frozen_string_literal: true

class CreateAwakenedWeaponTraits < ActiveRecord::Migration[7.1]
  def change
    create_table :awakened_weapon_traits do |t|
      t.string :trait, null: false
      t.float :min_value
      t.float :max_value

      t.timestamps
    end
    add_index :awakened_weapon_traits, :trait, unique: true
  end
end
