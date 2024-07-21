# frozen_string_literal: true

class AddTotalAssistCountToAlliances < ActiveRecord::Migration[7.1]
  def change
    add_column :alliances, :total_assist_count, :integer
  end
end
