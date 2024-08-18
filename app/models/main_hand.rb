# frozen_string_literal: true

class MainHand < ApplicationRecord
  belongs_to :main_hand_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :main_hands, optional: false
end
