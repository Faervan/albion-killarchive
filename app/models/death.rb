# frozen_string_literal: true

class Death < ApplicationRecord
  belongs_to :kill_event, inverse_of: :deaths

  belongs_to :player, inverse_of: :deaths

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
