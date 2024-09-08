# frozen_string_literal: true

class Chest < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :chest_type, foreign_key: 'item_type', inverse_of: :chests

  %I[kills deaths assists passive_assists].each do |models|
    has_many models, inverse_of: :chest, dependent: :destroy
  end

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
