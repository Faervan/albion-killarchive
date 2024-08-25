# frozen_string_literal: true

class Food < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :food_type, primary_key: 'path', inverse_of: 'item_type'

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
