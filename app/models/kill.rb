# frozen_string_literal: true

class Kill < ApplicationRecord
  belongs_to :kill_event, inverse_of: :kill
  belongs_to :player, inverse_of: :kills
  belongs_to :build, inverse_of: :kills
  %I[main_hand awakened_weapon off_hand head chest feet cape bag mount potion food].each do |model|
    belongs_to model, inverse_of: :kills, optional: true
  end

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
