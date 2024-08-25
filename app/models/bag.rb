# frozen_string_literal: true

class Bag < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :bag_type, foreign_key: 'item_type', inverse_of: :bags

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
