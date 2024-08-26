# frozen_string_literal: true

class Kill < ApplicationRecord
  belongs_to :kill_event, inverse_of: :kills

  belongs_to :player, inverse_of: :kills

  # belongs_to :build, inverse_of: :kills
  # belongs_to :main_hand, ...

  include PgSearch::Model
  pg_search_scope :search_by_player, against: :player_id, using: { tsearch: { prefix: true } }
end
