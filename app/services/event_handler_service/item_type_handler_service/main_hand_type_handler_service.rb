# frozen_string_literal: true

# "T6_2H_SHAPESHIFTER_MORGANA@2".match(/T(?<tier>[1-8])_(?<double>2H_)?(?<item_name>[^@]*)(@(?<enchantment>[0-4]))?/)
# "T6_2H_SHAPESHIFTER_MORGANA@2".match(/T[1-8](_)?(?<double>2H_)?(?<item_name>[^@]*)(@[0-4])?/)

class EventHandlerService::ItemTypeHandlerService::MainHandTypeHandlerService
  def handle_main_hand_types(event_list:)
    main_hand_types = build_main_hand_types(event_list:)
    update_main_hand_types(main_hand_types:, event_list:)
    persist_main_hand_types(main_hand_types:)
  end

  private

  def build_main_hand_types(event_list:)
    main_hand_types = event_list.flat_map do |event|
      build_main_hand_type_objects(event:)
    end
    main_hand_types.uniq
  end

  def build_main_hand_type_objects(event:)
    objects = []
    objects << build_main_hand_type_object(entity: event['Killer']) if main_hand_exists?(entity: event['Killer'])
    objects << build_main_hand_type_object(entity: event['Victim']) if main_hand_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_main_hand_type_object(entity: participant) if main_hand_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_main_hand_type_object(entity: member) if main_hand_exists?(entity: member)
    end
    objects
  end

  def build_main_hand_type_object(entity:)
    {
      name: entity['Equipment']['MainHand']['Type'].parse_main_hand_type[:path],
      path: entity['Equipment']['MainHand']['Type'].parse_main_hand_type[:path],
      two_handed: entity['Equipment']['MainHand']['Type'].parse_main_hand_type[:two_handed],
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def main_hand_exists?(entity:)
    !entity['Equipment']['MainHand'].nil?
  end

  def update_main_hand_types(main_hand_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(main_hand_types:, event:)
      update_deaths_and_ip(main_hand_types:, event:)
      update_assists_and_ip(main_hand_types:, event:)
    end
  end

  def update_kills_and_ip(main_hand_types:, event:)
    return unless main_hand_exists?(entity: event['Killer'])

    main_hand_type = find_main_hand_type(main_hand_types:, entity: event['Killer'])
    main_hand_type[:kills] += 1
    main_hand_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(main_hand_types:, event:)
    return unless main_hand_exists?(entity: event['Victim'])

    main_hand_type = find_main_hand_type(main_hand_types:, entity: event['Victim'])
    main_hand_type[:deaths] += 1
    main_hand_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(main_hand_types:, event:)
    event['Participants'].each do |participant|
      next if !main_hand_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      main_hand_type = find_main_hand_type(main_hand_types:, entity: participant)
      main_hand_type[:assists] += 1
      main_hand_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_main_hand_type(main_hand_types:, entity:)
    main_hand_types.detect { |a| a[:path] == entity['Equipment']['MainHand']['Type'].parse_main_hand_type[:path] }
  end

  def persist_main_hand_types(main_hand_types:)
    main_hand_types.each do |main_hand_type|
      next if main_hand_type[:path] == ''

      persist_main_hand_type(main_hand_type:)
    end
  end

  def persist_main_hand_type(main_hand_type:)
    MainHandType.create!(
      set_main_hand_type_stats(main_hand_type:).merge({ path: main_hand_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_main_hand_type(main_hand_type:)
  end

  def update_existing_main_hand_type(main_hand_type:)
    existing_main_hand_type = MainHandType.find_by(path: main_hand_type[:path])
    main_hand_type[:kills] += existing_main_hand_type.kills
    main_hand_type[:deaths] += existing_main_hand_type.deaths
    main_hand_type[:assists] += existing_main_hand_type.assists
    main_hand_type[:total_ip] += existing_main_hand_type.total_ip
    existing_main_hand_type.update(
      set_main_hand_type_stats(main_hand_type:)
    )
  end

  def set_main_hand_type_stats(main_hand_type:)
    usages = main_hand_type[:kills] + main_hand_type[:deaths] + main_hand_type[:assists]
    {
      name: main_hand_type[:name],
      two_handed?: main_hand_type[:two_handed],
      kills: main_hand_type[:kills],
      deaths: main_hand_type[:deaths],
      assists: main_hand_type[:assists],
      usages:,
      total_ip: main_hand_type[:total_ip],
      avg_ip:
        begin
          main_hand_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          (100.0 / (main_hand_type[:kills] + main_hand_type[:deaths]) * main_hand_type[:kills] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
