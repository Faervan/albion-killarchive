# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::AwakenedWeaponTraitHandlerService
  def handle_traits(souls:)
    traits = build_traits(souls:)
    persist_traits(traits: traits.uniq)
  end

  private

  def build_traits(souls:)
    souls.flat_map do |soul|
      traits = []
      traits << build_trait(trait: soul[:trait0]) unless soul[:trait0].nil?
      traits << build_trait(trait: soul[:trait1]) unless soul[:trait1].nil?
      traits << build_trait(trait: soul[:trait2]) unless soul[:trait2].nil?
      traits
    end
  end

  def build_trait(trait:)
    {
      trait: trait['trait'],
      min_value: trait['minvalue'],
      max_value: trait['maxvalue']
    }
  end

  def persist_traits(traits:)
    traits.each do |trait|
      AwakenedWeaponTrait.find_or_create_by(trait)
    end
  end
end
