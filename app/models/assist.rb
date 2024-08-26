# frozen_string_literal: true

class Assist < ApplicationRecord
  belongs_to :kill_event, inverse_of: :assists

  belongs_to :player, inverse_of: :assists

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
