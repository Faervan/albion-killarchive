# frozen_string_literal: true

class Guild < ApplicationRecord
  belongs_to :alliance, optional: true
  has_many :players, dependent: :nullify
end
