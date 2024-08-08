# frozen_string_literal: true

class Avatar < ApplicationRecord
  has_many :players, primary_key: 'avatar_id', inverse_of: 'avatar_id', dependent: :nullify
end
