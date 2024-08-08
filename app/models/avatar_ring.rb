# frozen_string_literal: true

class AvatarRing < ApplicationRecord
  has_many :players, primary_key: 'avatar_ring_id', inverse_of: 'avatar_ring_id', dependent: :nullify
end
