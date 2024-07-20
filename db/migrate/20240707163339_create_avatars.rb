# frozen_string_literal: true

class CreateAvatars < ActiveRecord::Migration[7.1]
  def change
    create_table :avatars do |t|
      t.string :avatar_id, null: false
      t.string :name

      t.timestamps
    end
  end
end
