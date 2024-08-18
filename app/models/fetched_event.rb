# frozen_string_literal: true

class FetchedEvent < ApplicationRecord
  scope :expired, -> { where(expires_at: ..Time.current) }
end
