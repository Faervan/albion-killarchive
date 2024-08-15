# frozen_string_literal: true

class CreateBagTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :bag_types do |t|
      t.string :path, null: false
      t.string :name
      t.integer :usages
      t.integer :avg_ip

      t.timestamps
    end

    add_index :bag_types, :path, unique: true
  end
end
