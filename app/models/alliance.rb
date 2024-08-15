# frozen_string_literal: true

class Alliance < ApplicationRecord
  self.primary_key = 'alliance_id'

  has_many :guilds, dependent: :nullify

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
