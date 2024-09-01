# frozen_string_literal: true

class AwakenedWeapon < ApplicationRecord
  self.primary_key = 'awakened_weapon_id'

  belongs_to :main_hand, -> { where(enchantment: 4) }, foreign_key: 'path', inverse_of: :awakened_weapons
  belongs_to :main_hand_type, foreign_key: 'item_type', inverse_of: :awakened_weapons
  belongs_to :player, foreign_key: 'attuned_player_id', inverse_of: :awakened_weapons
  belongs_to :trait0,
             class_name: 'AwakenedWeaponTrait', foreign_key: 'trait0', inverse_of: :awakened_weapons_trait0,
             optional: true
  belongs_to :trait1,
             class_name: 'AwakenedWeaponTrait', foreign_key: 'trait1', inverse_of: :awakened_weapons_trait1,
             optional: true
  belongs_to :trait2,
             class_name: 'AwakenedWeaponTrait', foreign_key: 'trait2', inverse_of: :awakened_weapons_trait2,
             optional: true
end
