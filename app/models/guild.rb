# frozen_string_literal: true

class Guild < ApplicationRecord
  self.primary_key = 'guild_id'

  belongs_to :alliance, optional: true
  has_many :players, dependent: :nullify
end
