# frozen_string_literal: true

class Kill < ApplicationRecord
  belongs_to :player
  belongs_to :kill_event
end
