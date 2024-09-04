# frozen_string_literal: true

class CreateBuilds < ActiveRecord::Migration[7.1]
  def change
    create_table :builds do |t|
      t.string :main_hand_type
      t.string :off_hand_type
      t.string :head_type
      t.string :chest_type
      t.string :feet_type
      t.string :cape_type
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :usages
      t.integer :kill_fame, limit: 8
      t.integer :death_fame, limit: 8
      t.integer :fame_ratio
      t.integer :total_ip, limit: 8
      t.integer :avg_ip
      t.integer :total_ip_diff
      t.integer :avg_ip_diff
      t.integer :kd_perc

      t.timestamps
    end
    [:main_hand_type, :off_hand_type, :head_type, :chest_type, :feet_type, :cape_type, :kills, :deaths, :assists, :usages,
     :kill_fame, :death_fame, :fame_ratio, :total_ip, :avg_ip, :total_ip_diff, :avg_ip_diff, :kd_perc].each do |name|
      add_index :builds, name
    end
    add_index :builds, [:main_hand_type, :off_hand_type, :head_type, :chest_type, :feet_type, :cape_type], unique: true, name: 'index_builds_on_unique_columns'
    [:main_hand_type, :off_hand_type, :head_type, :chest_type, :feet_type, :cape_type].each do |type|
      add_foreign_key(
        :builds,
        "#{type}s".to_sym,
        column: type,
        primary_key: :path
      )
    end
  end
end
