# frozen_string_literal: true

class Chest < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :chest_type, foreign_key: 'item_type', inverse_of: :chests

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
