# frozen_string_literal: true

class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.string :path, null: false
      t.string :name
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :usages
      t.integer :kd_perc

      t.timestamps
    end
    add_foreign_key(
      :foods,
      :food_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :foods, :path, unique: true
    [:name, :avg_ip, :kills, :deaths, :assists, :usages, :kd_perc].each do |name|
      add_index :foods, name
    end
  end
end
