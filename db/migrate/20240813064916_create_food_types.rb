# frozen_string_literal: true

class CreateFoodTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :food_types do |t|
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

    add_index :food_types, :path, unique: true
    [:avg_ip, :kills, :deaths, :assists, :usages, :kd_perc].each do |name|
      add_index :food_types, name
    end
  end
end
