# frozen_string_literal: true

class PotionType < ApplicationRecord
  self.primary_key = 'path'

  has_many :potions, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
