# frozen_string_literal: true

class Assist < ApplicationRecord
  belongs_to :player
  belongs_to :kill_event
end
