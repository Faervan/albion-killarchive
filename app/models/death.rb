# frozen_string_literal: true

class Death < ApplicationRecord
  %I[kill_event player build main_hand awakened_weapon off_hand head chest feet cape bag mount potion food].each do |model|
    belongs_to model, inverse_of: :deaths
  end

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
