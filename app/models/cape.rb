# frozen_string_literal: true

class Cape < ApplicationRecord
  belongs_to :cape_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :capes, optional: false
end
