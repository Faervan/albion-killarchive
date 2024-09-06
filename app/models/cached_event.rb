# frozen_string_literal: true

class CachedEvent < ApplicationRecord
  scope :expired, -> { where(expires_at: ..Time.current) }
end
