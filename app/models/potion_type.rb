# frozen_string_literal: true

class PotionType < ApplicationRecord
  has_many :potions, foreign_key: 'item_type', primary_key: 'path', inverse_of: :potion_type, dependent: :destroy
end
