# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::PotionTypeHandlerService
  def handle_potion_types(event_list:)
    potion_types = build_potion_types(event_list:)
    update_potion_types(potion_types:, event_list:)
    persist_potion_types(potion_types:)
  end

  private

  def build_potion_types(event_list:)
    potion_types = event_list.flat_map do |event|
      build_potion_type_objects(event:)
    end
    potion_types.uniq
  end

  def build_potion_type_objects(event:)
    objects = []
    objects << build_potion_type_object(entity: event['Killer']) if potion_exists?(entity: event['Killer'])
    objects << build_potion_type_object(entity: event['Victim']) if potion_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_potion_type_object(entity: participant) if potion_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_potion_type_object(entity: member) if potion_exists?(entity: member)
    end
    objects
  end

  def build_potion_type_object(entity:)
    {
      name: entity['Equipment']['Potion']['Type'].parse_item_type,
      path: entity['Equipment']['Potion']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def potion_exists?(entity:)
    !entity['Equipment']['Potion'].nil?
  end

  def update_potion_types(potion_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(potion_types:, event:)
      update_deaths_and_ip(potion_types:, event:)
      update_assists_and_ip(potion_types:, event:)
    end
  end

  def update_kills_and_ip(potion_types:, event:)
    return unless potion_exists?(entity: event['Killer'])

    potion_type = find_potion_type(potion_types:, entity: event['Killer'])
    potion_type[:kills] += 1
    potion_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(potion_types:, event:)
    return unless potion_exists?(entity: event['Victim'])

    potion_type = find_potion_type(potion_types:, entity: event['Victim'])
    potion_type[:deaths] += 1
    potion_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(potion_types:, event:)
    event['Participants'].each do |participant|
      next if !potion_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      potion_type = find_potion_type(potion_types:, entity: participant)
      potion_type[:assists] += 1
      potion_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_potion_type(potion_types:, entity:)
    potion_types.detect { |a| a[:path] == entity['Equipment']['Potion']['Type'].parse_item_type }
  end

  def persist_potion_types(potion_types:)
    potion_types.each do |potion_type|
      next if potion_type[:path] == ''

      persist_potion_type(potion_type:)
    end
  end

  def persist_potion_type(potion_type:)
    PotionType.create!(
      set_potion_type_stats(potion_type:).merge({ path: potion_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_potion_type(potion_type:)
  end

  def update_existing_potion_type(potion_type:)
    existing_potion_type = PotionType.find_by(path: potion_type[:path])
    potion_type[:kills] += existing_potion_type.kills
    potion_type[:deaths] += existing_potion_type.deaths
    potion_type[:assists] += existing_potion_type.assists
    potion_type[:total_ip] += existing_potion_type.total_ip
    existing_potion_type.update(
      set_potion_type_stats(potion_type:)
    )
  end

  def set_potion_type_stats(potion_type:)
    usages = potion_type[:kills] + potion_type[:deaths] + potion_type[:assists]
    {
      name: potion_type[:name],
      kills: potion_type[:kills],
      deaths: potion_type[:deaths],
      assists: potion_type[:assists],
      usages:,
      total_ip: potion_type[:total_ip],
      avg_ip:
        begin
          potion_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          100 / (potion_type[:kills] + potion_type[:deaths]) * (potion_type[:kills] * 100)
        rescue ZeroDivisionError
          0
        end
    }
  end
end
