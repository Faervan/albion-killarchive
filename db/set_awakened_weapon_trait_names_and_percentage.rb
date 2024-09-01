require './config/environment'

# Set name and percentage? columns of AwakenedWeaponTrait manually,
# as trait data is not available via the api (to my knowledge)

[
  {
    trait: 'TRAIT_ABILITY_DAMAGE',
    name: 'Ability Damage'
  },
  {
    trait: 'TRAIT_HITPOINTS_MAX',
    name: 'Max Health',
    percentage?: false
  },
  {
    trait: 'TRAIT_ITEM_POWER',
    name: 'Item Power',
    percentage?: false
  },
  {
    trait: 'TRAIT_AUTO_ATTACK_DAMAGE',
    name: 'Auto-Attack Damage'
  },
  {
    trait: 'TRAIT_COOLDOWN_REDUCTION',
    name: 'Cooldown Rate'
  },
  {
    trait: 'TRAIT_HEALING_DEALT',
    name: 'Healing Dealt'
  },
  {
    trait: 'TRAIT_DEFENSE_BONUS',
    name: 'Defense vs. All'
  },
  {
    trait: 'TRAIT_MOB_FAME',
    name: 'Mob Fame'
  },
  {
    trait: 'TRAIT_THREAT_BONUS',
    name: 'Threat Bonus'
  },
  {
    trait: 'TRAIT_LIFESTEAL',
    name: 'Life Steal'
  },
  {
    trait: 'TRAIT_HEALING_RECEIVED',
    name: 'Healing Received'
  },
  {
    trait: 'TRAIT_CAST_SPEED_INCREASE',
    name: 'Cast Time Reduction'
  },
  {
    trait: 'TRAIT_ENERGY_COST_REDUCTION',
    name: 'Engery Cost Reduction'
  },
  {
    trait: 'TRAIT_CC_RESIST',
    name: 'Crowd Control Resistance'
  },
  {
    trait: 'TRAIT_RESILIENCE_PENETRATION',
    name: 'Resilience Penetration'
  },
  {
    trait: 'TRAIT_ENERGY_MAX',
    name: 'Max Energy',
    percentage?: false
  },
  {
    trait: 'TRAIT_ATTACK_SPEED',
    name: 'Auto-Attack Speed'
  },
  {
    trait: 'TRAIT_CC_DURATION',
    name: 'Crowd Control Duration'
  },
  {
    trait: 'TRAIT_ATTACK_RANGE',
    name: 'Attack Range'
  }
].each do |hash|
  if (weapon = AwakenedWeaponTrait.find_by(trait: hash[:trait]))
    weapon.update!(hash.reject { |k,_| k == :trait })
  else
    puts "#{hash[:trait]} not yet available in database - rerun this script later!"
  end
end
