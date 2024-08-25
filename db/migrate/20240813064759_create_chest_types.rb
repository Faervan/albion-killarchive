# frozen_string_literal: true

class CreateChestTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :chest_types do |t|
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

    add_index :chest_types, :path, unique: true
  end
end
