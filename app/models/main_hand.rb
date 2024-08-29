# frozen_string_literal: true

class MainHand < ApplicationRecord
  self.primary_key = 'path'

  belongs_to :main_hand_type, foreign_key: 'item_type', inverse_of: :main_hands
  has_many :awakened_weapons, foreign_key: 'path', inverse_of: :main_hand, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
