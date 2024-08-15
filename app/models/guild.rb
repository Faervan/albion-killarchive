# frozen_string_literal: true

class Guild < ApplicationRecord
  belongs_to :alliance, optional: true
  has_many :players, primary_key: 'guild_id', inverse_of: 'guild_id', dependent: :nullify
end
