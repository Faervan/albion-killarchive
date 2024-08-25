# frozen_string_literal: true

class CreateMainHandTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :main_hand_types do |t|
      t.string :path, null: false
      t.string :name
      t.boolean :two_handed?, default: false
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :usages
      t.integer :kd_perc
      t.integer :base_ip

      t.timestamps
    end

    add_index :main_hand_types, :path, unique: true
  end
end
