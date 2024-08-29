# frozen_string_literal: true

class AwakenedWeapon < ApplicationRecord
  self.primary_key = 'awakened_weapon_id'

  belongs_to :main_hand, -> { where(enchantment: 4) }, foreign_key: 'path', inverse_of: :awakened_weapons
  belongs_to :main_hand_type, foreign_key: 'item_type', inverse_of: :awakened_weapons
  belongs_to :attuned_player_id, class_name: 'Player', foreign_key: 'attuned_player_id', inverse_of: :awakened_weapons
  belongs_to :crafted_player_id, class_name: 'Player', foreign_key: 'crafted_player_id', inverse_of: :awakened_weapons
  belongs_to :trait0, class_name: 'AwakenedWeaponTrait', foreign_key: 'trait0', inverse_of: :awakened_weapons
  belongs_to :trait1, class_name: 'AwakenedWeaponTrait', foreign_key: 'trait1', inverse_of: :awakened_weapons
  belongs_to :trait2, class_name: 'AwakenedWeaponTrait', foreign_key: 'trait2', inverse_of: :awakened_weapons
end
