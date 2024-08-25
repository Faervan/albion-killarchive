# frozen_string_literal: true

class Potion < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :potion_type, foreign_key: 'item_type', inverse_of: :potions

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
