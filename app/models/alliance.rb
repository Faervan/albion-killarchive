# frozen_string_literal: true

class Alliance < ApplicationRecord
  self.primary_key = 'alliance_id'

  has_many :guilds, dependent: :nullify
end
