# frozen_string_literal: true

class EventHandlerService::BuildHandlerService
  def handle_builds(event_list:)
    builds = build_builds(event_list:)
    update_builds(event_list:, builds:)
    persist_builds(builds:)
  end

  private

  def build_builds(event_list:)
    builds = event_list.flat_map do |event|
      build_build_objects(event:)
    end
    builds.uniq
  end

  def build_build_objects(event:)
    objects = []
    objects << build_build_object(entity: event['Killer'])
    objects << build_build_object(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_build_object(entity: participant)
    end
    objects
  end

  def build_build_object(entity:)
    {
      main_hand_type: get_type(entity:, type: 'MainHand'),
      off_hand_type: get_type(entity:, type: 'OffHand'),
      head_type: get_type(entity:, type: 'Head'),
      chest_type: get_type(entity:, type: 'Armor'),
      feet_type: get_type(entity:, type: 'Feet'),
      cape_type: get_type(entity:, type: 'Cape'),
      kills: 0,
      deaths: 0,
      assists: 0,
      kill_fame: 0,
      death_fame: 0,
      total_ip: 0,
      total_ip_diff: 0
    }
  end

  def get_type(entity:, type:)
    entity['Equipment'].dig(type, 'Type')&.parse_item_type
  end

  def update_builds(event_list:, builds:)
    event_list.each do |event|
      update_kill_count_and_fame(builds:, event:)
      update_death_count_and_fame(builds:, event:)
      update_assist_count(builds:, event:)
    end
  end

  def update_kill_count(builds:, event:)
    build = find_build(builds:, event:, target: ->(h) { h['Killer'] })
    build[:kills] += 1
    build[:kill_fame] += event['TotalVictimKillFame']
    build[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_death_count_and_fame(builds:, event:)
    build = find_build(builds:, event:, target: ->(h) { h['Victim'] })
    build[:total_death_count] += 1
    build[:total_death_fame] += event['TotalVictimKillFame']
    build[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assist_count(builds:, event:)
    event['Participants'].each_with_index do |participant, index|
      next if participant['Id'] == event['Killer']['Id']

      build = find_build(builds:, event:, target: ->(h) { h['Participants'][index] })
      build[:total_assist_count] += 1
      build[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_build(builds:, build_id:, target:)
    builds.detect { |build| build[:build_id] == build_id }
  end

  def persist_builds(builds:)
    builds.each do |build|
      build_stats = set_build_stats(build:)
      AwakenedWeapon.create!(
        {
          awakened_weapon_id: build[:awakened_weapon_id],
          item_type: build[:item_type]
        }.merge(build_stats)
      )
    rescue ActiveRecord::RecordNotUnique
      AwakenedWeapon.find(build[:awakened_weapon_id]).update!(build_stats)
    end
  end

  def set_build_stats(build:)
    new_build = {
      path: build[:path],
      last_equipped_at: build[:last_equipped_at],
      attuned_player_id: build[:attuned_player_id],
      attunement: build[:attunement],
      attunement_since_reset: build[:attunement_since_reset],
      crafted_player_name: build[:crafted_player_name],
      pvp_fame: build[:pvp_fame]
    }
    # The following magic handles the maybe existing traits and their values and rolls while not overgoing lint max class length
    [
      { trait: :trait0, trait_roll: :trait0_roll, trait_value: :trait0_value },
      { trait: :trait1, trait_roll: :trait1_roll, trait_value: :trait1_value },
      { trait: :trait2, trait_roll: :trait2_roll, trait_value: :trait2_value }
    ].each do |i|
      next if build[i[:trait]].nil?

      new_build.merge!(
        i[:trait] => AwakenedWeaponTrait.find(build[i[:trait]]['trait']),
        i[:trait_roll] => build[i[:trait]]['roll'],
        i[:trait_value] => build[i[:trait]]['value']
      )
    end
    new_build
  end
end
