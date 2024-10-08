# frozen_string_literal: true

class Player < ApplicationRecord
  self.primary_key = 'player_id'

  belongs_to :avatar, primary_key: 'avatar_id'
  belongs_to :avatar_ring, primary_key: 'avatar_ring_id'
  belongs_to :guild, optional: true
  has_many :awakened_weapons, foreign_key: 'attuned_player_id', inverse_of: :player, dependent: :destroy

  %I[kills deaths assists passive_assists].each do |models|
    has_many models, inverse_of: :player, dependent: :destroy
  end

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }
end
