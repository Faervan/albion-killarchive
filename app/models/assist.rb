# frozen_string_literal: true

class Assist < ApplicationRecord
  belongs_to :kill_event, inverse_of: :assists
  belongs_to :player, inverse_of: :assists
  belongs_to :build, inverse_of: :assists
  %I[main_hand awakened_weapon off_hand head chest feet cape bag mount potion food].each do |model|
    belongs_to model, inverse_of: :assists, optional: true
  end

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
