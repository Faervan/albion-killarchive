# frozen_string_literal: true

class CreateFeetTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :feet_types do |t|
      t.string :path, null: false
      t.string :name
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :usages
      t.integer :kd_perc

      t.timestamps
    end

    add_index :feet_types, :path, unique: true
  end
end
