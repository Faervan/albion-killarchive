# frozen_string_literal: true

class Bag < ApplicationRecord
  belongs_to :bag_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :bags, optional: false
end
