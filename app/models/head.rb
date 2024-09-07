# frozen_string_literal: true

class Head < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :head_type, foreign_key: 'item_type', inverse_of: :heads

  %I[kills deaths assists passive_assists].each do |models|
    has_many models, inverse_of: :head, dependent: :destroy
  end

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
