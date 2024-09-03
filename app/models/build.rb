# frozen_string_literal: true

class Build < ApplicationRecord
  belongs_to :main_hand_type, foreign_key: 'main_hand_type', inverse_of: :builds, optional: true
  belongs_to :off_hand_type, foreign_key: 'off_hand_type', inverse_of: :builds, optional: true
  belongs_to :head_type, foreign_key: 'head_type', inverse_of: :builds, optional: true
  belongs_to :chest_type, foreign_key: 'chest_type', inverse_of: :builds, optional: true
  belongs_to :feet_type, foreign_key: 'feet_type', inverse_of: :builds, optional: true
  belongs_to :cape_type, foreign_key: 'cape_type', inverse_of: :builds, optional: true

  validates :main_hand_type, uniqueness: { scope: %i[off_hand_type head_type chest_type feet_type cape_type] }
end
