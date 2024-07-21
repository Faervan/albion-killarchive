# frozen_string_literal: true

class AddTotalAssistCountToGuilds < ActiveRecord::Migration[7.1]
  def change
    add_column :guilds, :total_assist_count, :integer
  end
end
