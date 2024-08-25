# frozen_string_literal: true

class Bag < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :bag_type, primary_key: 'path', foreign_key: 'item_type'

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
