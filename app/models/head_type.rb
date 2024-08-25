# frozen_string_literal: true

class HeadType < ApplicationRecord
  self.primary_key = 'path'

  has_many :heads, foreign_key: 'item_type', inverse_of: :head_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
