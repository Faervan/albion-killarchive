# frozen_string_literal: true

class MainHandType < ApplicationRecord
  has_many :main_hands, foreign_key: 'item_type', primary_key: 'path', inverse_of: :main_hand_type, dependent: :destroy
end
