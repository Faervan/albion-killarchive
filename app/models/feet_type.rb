# frozen_string_literal: true

class FeetType < ApplicationRecord
  self.primary_key = 'path'

  has_many :feets, foreign_key: 'item_type', inverse_of: :feet_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
