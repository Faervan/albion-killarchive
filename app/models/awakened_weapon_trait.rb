# frozen_string_literal: true

class AwakenedWeaponTrait < ApplicationRecord
  self.primary_key = 'trait'

  has_many :awakened_weapons_trait0, class_name: 'AwakenedWeapon', foreign_key: 'trait0', inverse_of: :trait, dependent: :destroy
  has_many :awakened_weapons_trait1, class_name: 'AwakenedWeapon', foreign_key: 'trait1', inverse_of: :trait, dependent: :destroy
  has_many :awakened_weapons_trait2, class_name: 'AwakenedWeapon', foreign_key: 'trait2', inverse_of: :trait, dependent: :destroy
end
