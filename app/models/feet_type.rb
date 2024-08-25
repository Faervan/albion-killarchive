# frozen_string_literal: true

class FeetType < ApplicationRecord
  self.primary_key = 'path'

  has_many :feets, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
