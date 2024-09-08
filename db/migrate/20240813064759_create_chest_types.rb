# frozen_string_literal: true

class CreateChestTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :chest_types do |t|
      t.string :path, null: false
      t.string :name
      t.integer :total_ip
      t.integer :avg_ip
      t.integer :kill_count
      t.integer :death_count
      t.integer :assist_count
      t.integer :usage_count
      t.integer :kd_perc
      t.integer :base_ip

      t.timestamps
    end

    add_index :chest_types, :path, unique: true
    [:name, :avg_ip, :kill_count, :death_count, :assist_count, :usage_count, :kd_perc].each do |name|
      add_index :chest_types, name
    end
  end
end
