# frozen_string_literal: true

class ChestType < ApplicationRecord
  has_many :chests, foreign_key: 'item_type', primary_key: 'path', inverse_of: :chest_type, dependent: :destroy
end
