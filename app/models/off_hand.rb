# frozen_string_literal: true

class OffHand < ApplicationRecord
  belongs_to :off_hand_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :off_hands, optional: false
end
