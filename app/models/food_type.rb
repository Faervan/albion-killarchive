# frozen_string_literal: true

class FoodType < ApplicationRecord
  has_many :foods, foreign_key: 'item_type', primary_key: 'path', inverse_of: :food_type, dependent: :destroy
end
