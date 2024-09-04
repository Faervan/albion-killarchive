# frozen_string_literal: true

class MainHandType < ApplicationRecord
  self.primary_key = 'path'

  has_many :main_hands, foreign_key: 'item_type', inverse_of: :main_hand_type, dependent: :destroy
  has_many :awakened_weapons, foreign_key: 'item_type', inverse_of: :main_hand_type, dependent: :destroy
  has_many :builds, foreign_key: 'main_hand_type', inverse_of: :main_hand_type, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
