# frozen_string_literal: true

class ChestType < ApplicationRecord
  self.primary_key = 'path'

  has_many :chests, foreign_key: 'item_type', inverse_of: :chest_type, dependent: :destroy
  has_many :builds, foreign_key: 'chest_type', inverse_of: :chest_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
