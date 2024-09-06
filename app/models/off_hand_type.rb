# frozen_string_literal: true

class OffHandType < ApplicationRecord
  self.primary_key = 'path'

  has_many :off_hands, foreign_key: 'item_type', inverse_of: :off_hand_type, dependent: :destroy
  has_many :builds, foreign_key: 'off_hand_type', inverse_of: :off_hand_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
