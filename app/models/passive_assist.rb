# frozen_string_literal: true

class PassiveAssist < ApplicationRecord
  %I[kill_event player main_hand awakened_weapon].each do |model|
    belongs_to model, inverse_of: :passive_assists
  end

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
