# frozen_string_literal: true

class BagType < ApplicationRecord
  self.primary_key = 'path'

  has_many :bags, foreign_key: 'item_type', inverse_of: :bag_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
