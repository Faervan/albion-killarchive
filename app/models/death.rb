# frozen_string_literal: true

class Death < ApplicationRecord
  belongs_to :kill_event, inverse_of: :death
  belongs_to :player, inverse_of: :deaths
  belongs_to :build, inverse_of: :deaths
  %I[main_hand awakened_weapon off_hand head chest feet cape bag mount potion food].each do |model|
    belongs_to model, inverse_of: :deaths, optional: true
  end

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
