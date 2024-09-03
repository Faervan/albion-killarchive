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
      feet_type: get_type(entity:, type: 'Shoes'),
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
    entity['Equipment'].dig(type, 'Type')&.parse_item_type&.[](:path)
  end

  def update_builds(event_list:, builds:)
    event_list.each do |event|
      update_kill_count_and_fame(builds:, event:)
      update_death_count_and_fame(builds:, event:)
      update_assist_count(builds:, event:)
    end
  end

  def update_kill_count_and_fame(builds:, event:)
    build = find_build(builds:, entity: event['Killer'])
    build[:kills] += 1
    build[:kill_fame] += event['TotalVictimKillFame']
    build[:total_ip] += event['Killer']['AverageItemPower']
    return if event['Killer']['AverageItemPower'].zero? || event['Victim']['AverageItemPower'].zero?

    build[:total_ip_diff] += event['Killer']['AverageItemPower'] - event['Victim']['AverageItemPower']
  end

  def update_death_count_and_fame(builds:, event:)
    build = find_build(builds:, entity: event['Victim'])
    build[:deaths] += 1
    build[:death_fame] += event['TotalVictimKillFame']
    build[:total_ip] += event['Victim']['AverageItemPower']
    return if event['Killer']['AverageItemPower'].zero? || event['Victim']['AverageItemPower'].zero?

    build[:total_ip_diff] -= event['Killer']['AverageItemPower'] - event['Victim']['AverageItemPower']
  end

  def update_assist_count(builds:, event:)
    event['Participants'].each do |participant|
      next if participant['Id'] == event['Killer']['Id']

      build = find_build(builds:, entity: participant)
      build[:assists] += 1
      build[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_build(builds:, entity:)
    builds.detect do |build|
      get_type(entity:, type: 'MainHand') == build[:main_hand_type] &&
        get_type(entity:, type: 'OffHand') == build[:off_hand_type] &&
        get_type(entity:, type: 'Head') == build[:head_type] &&
        get_type(entity:, type: 'Armor') == build[:chest_type] &&
        get_type(entity:, type: 'Shoes') == build[:feet_type] &&
        get_type(entity:, type: 'Cape') == build[:cape_type]
    end
  end

  def persist_builds(builds:)
    builds.each do |build|
      build_stats = build.merge(set_build_stats(build:))
      Build.create!(build_stats.merge(get_build_key(build:)))
      #puts 'created new thing'
    rescue ActiveRecord::RecordInvalid
      existing_build = Build.find_by(get_build_key(build:))
      existing_build.update!(update_build_stats(build:, existing_build:))
    end
  end

  def set_build_stats(build:)
    usages = build[:kills] + build[:deaths] + build[:assists]
    {
      fame_ratio: build[:death_fame].zero? ? 0 : (build[:kill_fame] / build[:death_fame] * 100).round,
      usages:,
      avg_ip: usages.positive? ? build[:total_ip] / usages : 0,
      kd_perc:
        begin
          (100.0 / (build[:kills] + build[:deaths]) * build[:kills] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end

  def get_build_key(build:)
    {
      main_hand_type: MainHandType.find_by(path: build[:main_hand_type]),
      off_hand_type: OffHandType.find_by(path: build[:off_hand_type]),
      head_type: HeadType.find_by(path: build[:main_hand_type]),
      chest_type: ChestType.find_by(path: build[:chest_type]),
      feet_type: FeetType.find_by(path: build[:feet_type]),
      cape_type: CapeType.find_by(path: build[:cape_type])
    }
  end

  def update_build_stats(build:, existing_build:)
    build[:kills] += existing_build.kills
    build[:deaths] += existing_build.deaths
    build[:assists] += existing_build.assists
    build[:kill_fame] += existing_build.kill_fame
    build[:death_fame] += existing_build.kill_fame
    build[:total_ip] += existing_build.total_ip
    build[:total_ip_diff] += existing_build.total_ip_diff
    build.delete(:main_hand_type)
    build.delete(:off_hand_type)
    build.delete(:head_type)
    build.delete(:chest_type)
    build.delete(:feet_type)
    build.delete(:cape_type)
    build.merge(set_build_stats(build:))
  end
end
