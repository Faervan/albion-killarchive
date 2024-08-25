# frozen_string_literal: true

class CapeType < ApplicationRecord
  self.primary_key = 'path'

  has_many :capes, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
