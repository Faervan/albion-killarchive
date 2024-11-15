# frozen_string_literal: true

class CreatePotions < ActiveRecord::Migration[7.1]
  def change
    create_table :potions do |t|
      t.string :path, null: false
      t.string :name
      t.string :item_type, null: false
      t.integer :tier
      t.integer :enchantment
      t.integer :total_ip, limit: 8
      t.integer :avg_ip
      t.integer :kill_count
      t.integer :death_count
      t.integer :assist_count
      t.integer :usage_count
      t.integer :kd_perc

      t.timestamps
    end
    add_foreign_key(
      :potions,
      :potion_types,
      column: :item_type,
      primary_key: :path
    )
    add_index :potions, :path, unique: true
    [:name, :avg_ip, :kill_count, :death_count, :assist_count, :usage_count, :kd_perc].each do |name|
      add_index :potions, name
    end
  end
end
