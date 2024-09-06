# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::AwakenedWeaponHandlerService
  def handle_awakened_weapons(event_list:)
    souls = build_souls(event_list:)
    EventHandlerService::ItemHandlerService::AwakenedWeaponTraitHandlerService.new.handle_traits(souls:)
    persist_souls(souls:)
  end

  private

  def build_souls(event_list:)
    all_souls = event_list.flat_map do |event|
      build_soul_objects(event:)
    end
    all_souls.group_by { |hash| hash[:awakened_weapon_id] }.map do |_, soul_hashes|
      soul_hashes.max_by { |hash| hash[:event_id] }
    end
  end

  def build_soul_objects(event:)
    objects = []
    objects << build_soul_object(entity: event['Killer'], event_id: event['EventId']) if soul_exists?(entity: event['Killer'])
    objects << build_soul_object(entity: event['Victim'], event_id: event['EventId']) if soul_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_soul_object(entity: participant, event_id: event['EventId']) if soul_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_soul_object(entity: member, event_id: event['EventId']) if soul_exists?(entity: member)
    end
    objects
  end

  def build_soul_object(entity:, event_id:)
    item = entity['Equipment']['MainHand']
    soul = item['LegendarySoul']
    parsed_item = item['Type'].parse_item
    {
      event_id:,
      awakened_weapon_id: soul['id'],
      path: "#{parsed_item[:path]}_Q#{item['Quality']}",
      item_type: item['Type'].parse_item_type[:path],
      last_equipped_at: soul['lastEquipped'].to_datetime.utc,
      attuned_player_id: entity['Id'],
      attunement: soul['attunement'],
      attunement_since_reset: soul['attunementSpentSinceReset'],
      crafted_player_name: soul['craftedBy'],
      pvp_fame: soul['PvPFameGained'],
      trait0: soul['traits'][0],
      trait1: soul['traits'][1],
      trait2: soul['traits'][2]
    }
  end

  def soul_exists?(entity:)
    !entity.dig('Equipment', 'MainHand', 'LegendarySoul').nil?
  end

  def persist_souls(souls:)
    souls.each do |soul|
      soul_stats = set_soul_stats(soul:)
      AwakenedWeapon.create!(
        {
          awakened_weapon_id: soul[:awakened_weapon_id],
          item_type: soul[:item_type]
        }.merge(soul_stats)
      )
    rescue ActiveRecord::RecordNotUnique
      AwakenedWeapon.find(soul[:awakened_weapon_id]).update!(soul_stats)
    end
  end

  def set_soul_stats(soul:)
    new_soul = {
      path: soul[:path],
      last_equipped_at: soul[:last_equipped_at],
      attuned_player_id: soul[:attuned_player_id],
      attunement: soul[:attunement],
      attunement_since_reset: soul[:attunement_since_reset],
      crafted_player_name: soul[:crafted_player_name],
      pvp_fame: soul[:pvp_fame]
    }
    # The following magic handles the maybe existing traits and their values and rolls while not overgoing lint max class length
    [
      { trait: :trait0, trait_roll: :trait0_roll, trait_value: :trait0_value },
      { trait: :trait1, trait_roll: :trait1_roll, trait_value: :trait1_value },
      { trait: :trait2, trait_roll: :trait2_roll, trait_value: :trait2_value }
    ].each do |i|
      next if soul[i[:trait]].nil?

      new_soul.merge!(
        i[:trait] => AwakenedWeaponTrait.find(soul[i[:trait]]['trait']),
        i[:trait_roll] => soul[i[:trait]]['roll'],
        i[:trait_value] => soul[i[:trait]]['value']
      )
    end
    new_soul
  end
end
