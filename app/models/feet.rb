# frozen_string_literal: true

class Feet < ApplicationRecord
  belongs_to :feet_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :feets, optional: false
end
