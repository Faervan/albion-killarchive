# frozen_string_literal: true

class CreateHeadTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :head_types do |t|
      t.string :path, null: false
      t.string :name
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

    add_index :head_types, :path, unique: true
    [:name, :avg_ip, :kills, :deaths, :assists, :usages, :kd_perc].each do |name|
      add_index :head_types, name
    end
  end
end
