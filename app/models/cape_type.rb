# frozen_string_literal: true

class CapeType < ApplicationRecord
  has_many :capes, foreign_key: 'item_type', primary_key: 'path', inverse_of: :cape_type, dependent: :destroy
end
