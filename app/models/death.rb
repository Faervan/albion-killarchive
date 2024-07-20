# frozen_string_literal: true

class Death < ApplicationRecord
  belongs_to :player
  belongs_to :kill_event
end
