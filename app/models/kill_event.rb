# frozen_string_literal: true

class KillEvent < ApplicationRecord
  self.primary_key = 'kill_event_id'

  has_one :kill, inverse_of: :kill_event, dependent: :destroy
  has_one :death, inverse_of: :kill_event, dependent: :destroy
  has_many :assists, inverse_of: :kill_event, dependent: :destroy
  has_many :passive_assists, inverse_of: :kill_event, dependent: :destroy
end
