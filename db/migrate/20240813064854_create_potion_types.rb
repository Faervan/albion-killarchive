# frozen_string_literal: true

class CreatePotionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :potion_types do |t|
      t.string :path, null: false
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :usages
      t.integer :kd_perc

      t.timestamps
    end

    add_index :potion_types, :path, unique: true
  end
end
