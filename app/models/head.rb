# frozen_string_literal: true

class Head < ApplicationRecord
  belongs_to :head_type, foreign_key: 'item_type', primary_key: 'path', inverse_of: :heads, optional: false
end
