# frozen_string_literal: true

class HeadType < ApplicationRecord
  has_many :heads, foreign_key: 'item_type', primary_key: 'path', inverse_of: :head_type, dependent: :destroy
end
