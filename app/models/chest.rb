# frozen_string_literal: true

class Chest < ApplicationRecord
  belongs_to :chest_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :chests, optional: false
end
