# frozen_string_literal: true

class EventHandlerService::AllianceHandlerService
  def handle_alliances(event_list:)
    alliances = build_alliances(event_list:)
    update_alliances(alliances:, event_list:)
    persist_alliances(alliances:)
  end

  private

  def build_alliances(event_list:)
    alliances = event_list.flat_map do |event|
      build_alliance_objects(event:)
    end
    alliances.uniq
  end

  def build_alliance_objects(event:)
    objects = []
    objects << build_alliance_object(entity: event['Victim'])
    event['Participants'].each { |participant| objects << build_alliance_object(entity: participant) }
    event['GroupMembers'].each { |member| objects << build_alliance_object(entity: member) }
    objects
  end

  def build_alliance_object(entity:)
    {
      alliance_name: entity['AllianceName'],
      alliance_id: entity['AllianceId'],
      total_kill_fame: 0,
      total_death_fame: 0,
      total_kill_count: 0,
      total_death_count: 0
    }
  end

  def update_alliances(alliances:, event_list:)
    event_list.each do |event|
      update_kill_count(alliances:, event:)
      update_kill_fame(alliances:, event:)
      update_death_count_and_fame(alliances:, event:)
    end
  end

  def update_kill_count(alliances:, event:)
    return if event['Killer']['AllianceId'] == ''

    alliance = find_alliance(alliances:, alliance_id: event['Killer']['AllianceId'])
    alliance[:total_kill_count] += 1
  end

  def update_kill_fame(alliances:, event:)
    event['GroupMembers'].each do |member|
      next if member['AllianceId'] == ''

      alliance = find_alliance(alliances:, alliance_id: member['AllianceId'])
      alliance[:total_kill_fame] += member['KillFame']
    end
  end

  def update_death_count_and_fame(alliances:, event:)
    return if event['Victim']['AllianceId'] == ''

    alliance = find_alliance(alliances:, alliance_id: event['Victim']['AllianceId'])
    alliance[:total_death_count] += 1
    alliance[:total_death_fame] += event['TotalVictimKillFame']
  end

  def find_alliance(alliances:, alliance_id:)
    alliances.detect { |a| a[:alliance_id] == alliance_id }
  end

  def persist_alliances(alliances:)
    alliances.each do |alliance|
      next if alliance[:alliance_id] == ''

      persist_alliance(alliance:)
    end
  end

  def persist_alliance(alliance:)
    Alliance.create!(
      alliance_id: alliance[:alliance_id],
      name: alliance[:alliance_name],
      total_kill_fame: alliance[:total_kill_fame],
      total_death_fame: alliance[:total_death_fame],
      total_kill_count: alliance[:total_kill_count],
      total_death_count: alliance[:total_death_count]
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_alliance(alliance:)
  end

  def update_existing_alliance(alliance:)
    existing_alliance = Alliance.find_by(alliance_id: alliance[:alliance_id])
    alliance[:total_kill_fame] += existing_alliance.total_kill_fame
    alliance[:total_kill_count] += existing_alliance.total_kill_count
    alliance[:total_death_fame] += existing_alliance.total_death_fame
    alliance[:total_death_count] += existing_alliance.total_death_count
    existing_alliance.update(
      name: alliance[:alliance_name],
      total_kill_fame: alliance[:total_kill_fame],
      total_death_fame: alliance[:total_death_fame],
      total_kill_count: alliance[:total_kill_count],
      total_death_count: alliance[:total_death_count]
    )
  end
end
