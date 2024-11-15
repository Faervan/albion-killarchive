# frozen_string_literal: true

class CreateCapeTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :cape_types do |t|
      t.string :path, null: false
      t.string :name
      t.integer :total_ip, limit: 8
      t.integer :avg_ip
      t.integer :kill_count
      t.integer :death_count
      t.integer :assist_count
      t.integer :usage_count
      t.integer :kd_perc

      t.timestamps
    end

    add_index :cape_types, :path, unique: true
    [:name, :avg_ip, :kill_count, :death_count, :assist_count, :usage_count, :kd_perc].each do |name|
      add_index :cape_types, name
    end
  end
end
