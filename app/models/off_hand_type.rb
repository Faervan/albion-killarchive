# frozen_string_literal: true

class OffHandType < ApplicationRecord
  has_many :off_hands, foreign_key: 'item_type', primary_key: 'path', inverse_of: :off_hand_type, dependent: :destroy
end
