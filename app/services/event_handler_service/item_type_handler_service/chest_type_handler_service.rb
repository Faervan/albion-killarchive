# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::ChestTypeHandlerService
  def handle_chest_types(event_list:)
    chest_types = build_chest_types(event_list:)
    update_chest_types(chest_types:, event_list:)
    persist_chest_types(chest_types:)
  end

  private

  def build_chest_types(event_list:)
    chest_types = event_list.flat_map do |event|
      build_chest_type_objects(event:)
    end
    chest_types.uniq
  end

  def build_chest_type_objects(event:)
    objects = []
    objects << build_chest_type_object(entity: event['Killer']) if chest_exists?(entity: event['Killer'])
    objects << build_chest_type_object(entity: event['Victim']) if chest_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_chest_type_object(entity: participant) if chest_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_chest_type_object(entity: member) if chest_exists?(entity: member)
    end
    objects
  end

  def build_chest_type_object(entity:)
    {
      name: entity['Equipment']['Armor']['Type'].parse_item_type,
      path: entity['Equipment']['Armor']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def chest_exists?(entity:)
    !entity['Equipment']['Armor'].nil?
  end

  def update_chest_types(chest_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(chest_types:, event:)
      update_deaths_and_ip(chest_types:, event:)
      update_assists_and_ip(chest_types:, event:)
    end
  end

  def update_kills_and_ip(chest_types:, event:)
    return unless chest_exists?(entity: event['Killer'])

    chest_type = find_chest_type(chest_types:, entity: event['Killer'])
    chest_type[:kills] += 1
    chest_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(chest_types:, event:)
    return unless chest_exists?(entity: event['Victim'])

    chest_type = find_chest_type(chest_types:, entity: event['Victim'])
    chest_type[:deaths] += 1
    chest_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(chest_types:, event:)
    event['Participants'].each do |participant|
      next if !chest_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      chest_type = find_chest_type(chest_types:, entity: participant)
      chest_type[:assists] += 1
      chest_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_chest_type(chest_types:, entity:)
    chest_types.detect { |a| a[:path] == entity['Equipment']['Armor']['Type'].parse_item_type }
  end

  def persist_chest_types(chest_types:)
    chest_types.each do |chest_type|
      next if chest_type[:path] == ''

      persist_chest_type(chest_type:)
    end
  end

  def persist_chest_type(chest_type:)
    ChestType.create!(
      set_chest_type_stats(chest_type:).merge({ path: chest_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_chest_type(chest_type:)
  end

  def update_existing_chest_type(chest_type:)
    existing_chest_type = ChestType.find_by(path: chest_type[:path])
    chest_type[:kills] += existing_chest_type.kills
    chest_type[:deaths] += existing_chest_type.deaths
    chest_type[:assists] += existing_chest_type.assists
    chest_type[:total_ip] += existing_chest_type.total_ip
    existing_chest_type.update(
      set_chest_type_stats(chest_type:)
    )
  end

  def set_chest_type_stats(chest_type:)
    usages = chest_type[:kills] + chest_type[:deaths] + chest_type[:assists]
    {
      name: chest_type[:name],
      kills: chest_type[:kills],
      deaths: chest_type[:deaths],
      assists: chest_type[:assists],
      usages:,
      total_ip: chest_type[:total_ip],
      avg_ip:
        begin
          chest_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          100 / (chest_type[:kills] + chest_type[:deaths]) * (chest_type[:kills] * 100)
        rescue ZeroDivisionError
          0
        end
    }
  end
end
