# frozen_string_literal: true

class FeetType < ApplicationRecord
  has_many :feets, foreign_key: 'item_type', primary_key: 'path', inverse_of: :feet_type, dependent: :destroy
end
