# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::FeetTypeHandlerService
  def handle_feet_types(event_list:)
    feet_types = build_feet_types(event_list:)
    update_feet_types(feet_types:, event_list:)
    persist_feet_types(feet_types:)
  end

  private

  def build_feet_types(event_list:)
    feet_types = event_list.flat_map do |event|
      build_feet_type_objects(event:)
    end
    feet_types.uniq
  end

  def build_feet_type_objects(event:)
    objects = []
    objects << build_feet_type_object(entity: event['Killer']) if feet_exists?(entity: event['Killer'])
    objects << build_feet_type_object(entity: event['Victim']) if feet_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_feet_type_object(entity: participant) if feet_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_feet_type_object(entity: member) if feet_exists?(entity: member)
    end
    objects
  end

  def build_feet_type_object(entity:)
    {
      name: entity['Equipment']['Shoes']['Type'].parse_item_type,
      path: entity['Equipment']['Shoes']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def feet_exists?(entity:)
    !entity['Equipment']['Shoes'].nil?
  end

  def update_feet_types(feet_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(feet_types:, event:)
      update_deaths_and_ip(feet_types:, event:)
      update_assists_and_ip(feet_types:, event:)
    end
  end

  def update_kills_and_ip(feet_types:, event:)
    return unless feet_exists?(entity: event['Killer'])

    feet_type = find_feet_type(feet_types:, entity: event['Killer'])
    feet_type[:kills] += 1
    feet_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(feet_types:, event:)
    return unless feet_exists?(entity: event['Victim'])

    feet_type = find_feet_type(feet_types:, entity: event['Victim'])
    feet_type[:deaths] += 1
    feet_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(feet_types:, event:)
    event['Participants'].each do |participant|
      next if !feet_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      feet_type = find_feet_type(feet_types:, entity: participant)
      feet_type[:assists] += 1
      feet_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_feet_type(feet_types:, entity:)
    feet_types.detect { |a| a[:path] == entity['Equipment']['Shoes']['Type'].parse_item_type }
  end

  def persist_feet_types(feet_types:)
    feet_types.each do |feet_type|
      next if feet_type[:path] == ''

      persist_feet_type(feet_type:)
    end
  end

  def persist_feet_type(feet_type:)
    FeetType.create!(
      set_feet_type_stats(feet_type:).merge({ path: feet_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_feet_type(feet_type:)
  end

  def update_existing_feet_type(feet_type:)
    existing_feet_type = FeetType.find_by(path: feet_type[:path])
    feet_type[:kills] += existing_feet_type.kills
    feet_type[:deaths] += existing_feet_type.deaths
    feet_type[:assists] += existing_feet_type.assists
    feet_type[:total_ip] += existing_feet_type.total_ip
    existing_feet_type.update(
      set_feet_type_stats(feet_type:)
    )
  end

  def set_feet_type_stats(feet_type:)
    usages = feet_type[:kills] + feet_type[:deaths] + feet_type[:assists]
    {
      name: feet_type[:name],
      kills: feet_type[:kills],
      deaths: feet_type[:deaths],
      assists: feet_type[:assists],
      usages:,
      total_ip: feet_type[:total_ip],
      avg_ip:
        begin
          feet_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          100 / (feet_type[:kills] + feet_type[:deaths]) * (feet_type[:kills] * 100)
        rescue ZeroDivisionError
          0
        end
    }
  end
end
