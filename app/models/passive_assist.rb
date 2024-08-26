# frozen_string_literal: true

class PassiveAssist < ApplicationRecord
  belongs_to :kill_event, inverse_of: :passive_assists

  belongs_to :player, inverse_of: :passive_assists

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
