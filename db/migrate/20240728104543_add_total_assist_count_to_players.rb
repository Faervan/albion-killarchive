# frozen_string_literal: true

class AddTotalAssistCountToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :total_assist_count, :integer
  end
end
