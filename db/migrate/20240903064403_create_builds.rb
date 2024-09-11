# frozen_string_literal: true

class CreateBuilds < ActiveRecord::Migration[7.1]
  def change
    create_table :builds do |t|
      t.string :main_hand_type_path
      t.string :off_hand_type_path
      t.string :head_type_path
      t.string :chest_type_path
      t.string :feet_type_path
      t.string :cape_type_path
      t.integer :kill_count
      t.integer :death_count
      t.integer :assist_count
      t.integer :usage_count
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
    %I[main_hand_type_path off_hand_type_path head_type_path chest_type_path feet_type_path cape_type_path kill_count death_count assist_count usage_count
     kill_fame death_fame fame_ratio total_ip avg_ip total_ip_diff avg_ip_diff kd_perc].each do |name|
      add_index :builds, name
    end
    add_index :builds, %I[main_hand_type_path off_hand_type_path head_type_path chest_type_path feet_type_path cape_type_path], unique: true, name: 'index_builds_on_unique_columns'
    %I[main_hand_type_path off_hand_type_path head_type_path chest_type_path feet_type_path cape_type_path].each do |type|
      add_foreign_key(
        :builds,
        type.to_s.sub(/_path/, 's').to_sym,
        column: type,
        primary_key: :path
      )
    end
  end
end
