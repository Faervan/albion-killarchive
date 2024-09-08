# frozen_string_literal: true

class CreateFoodTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :food_types do |t|
      t.string :path, null: false
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kill_count
      t.integer :death_count
      t.integer :assist_count
      t.integer :usage_count
      t.integer :kd_perc

      t.timestamps
    end

    add_index :food_types, :path, unique: true
    [:avg_ip, :kill_count, :death_count, :assist_count, :usage_count, :kd_perc].each do |name|
      add_index :food_types, name
    end
  end
end
