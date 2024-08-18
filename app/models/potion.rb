# frozen_string_literal: true

class Potion < ApplicationRecord
  belongs_to :potion_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :potions, optional: false
end
