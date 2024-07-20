# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :avatar
  belongs_to :avatar_ring
  belongs_to :guild
end
