# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to :food_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :foods, optional: false
end
