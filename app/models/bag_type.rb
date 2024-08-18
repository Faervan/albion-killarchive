# frozen_string_literal: true

class BagType < ApplicationRecord
  has_many :bags, foreign_key: 'item_type', primary_key: 'path', inverse_of: :bag_type, dependent: :destroy
end
