# frozen_string_literal: true

class Alliance < ApplicationRecord
  has_many :guilds, primary_key: 'alliance_id', inverse_of: 'alliance_id', dependent: :nullify
end
