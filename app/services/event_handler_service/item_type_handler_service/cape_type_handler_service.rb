# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::CapeTypeHandlerService
  def handle_cape_types(event_list:)
    cape_types = build_cape_types(event_list:)
    update_cape_types(cape_types:, event_list:)
    persist_cape_types(cape_types:)
  end

  private

  def build_cape_types(event_list:)
    cape_types = event_list.flat_map do |event|
      build_cape_type_objects(event:)
    end
    cape_types.uniq
  end

  def build_cape_type_objects(event:)
    objects = []
    objects << build_cape_type_object(entity: event['Killer']) if cape_exists?(entity: event['Killer'])
    objects << build_cape_type_object(entity: event['Victim']) if cape_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_cape_type_object(entity: participant) if cape_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_cape_type_object(entity: member) if cape_exists?(entity: member)
    end
    objects
  end

  def build_cape_type_object(entity:)
    {
      name: entity['Equipment']['Cape']['Type'].parse_item_type,
      path: entity['Equipment']['Cape']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def cape_exists?(entity:)
    !entity['Equipment']['Cape'].nil?
  end

  def update_cape_types(cape_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(cape_types:, event:)
      update_deaths_and_ip(cape_types:, event:)
      update_assists_and_ip(cape_types:, event:)
    end
  end

  def update_kills_and_ip(cape_types:, event:)
    return unless cape_exists?(entity: event['Killer'])

    cape_type = find_cape_type(cape_types:, entity: event['Killer'])
    cape_type[:kills] += 1
    cape_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(cape_types:, event:)
    return unless cape_exists?(entity: event['Victim'])

    cape_type = find_cape_type(cape_types:, entity: event['Victim'])
    cape_type[:deaths] += 1
    cape_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(cape_types:, event:)
    event['Participants'].each do |participant|
      next if !cape_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      cape_type = find_cape_type(cape_types:, entity: participant)
      cape_type[:assists] += 1
      cape_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_cape_type(cape_types:, entity:)
    cape_types.detect { |a| a[:path] == entity['Equipment']['Cape']['Type'].parse_item_type }
  end

  def persist_cape_types(cape_types:)
    cape_types.each do |cape_type|
      next if cape_type[:path] == ''

      persist_cape_type(cape_type:)
    end
  end

  def persist_cape_type(cape_type:)
    CapeType.create!(
      set_cape_type_stats(cape_type:).merge({ path: cape_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_cape_type(cape_type:)
  end

  def update_existing_cape_type(cape_type:)
    existing_cape_type = CapeType.find_by(path: cape_type[:path])
    cape_type[:kills] += existing_cape_type.kills
    cape_type[:deaths] += existing_cape_type.deaths
    cape_type[:assists] += existing_cape_type.assists
    cape_type[:total_ip] += existing_cape_type.total_ip
    existing_cape_type.update(
      set_cape_type_stats(cape_type:)
    )
  end

  def set_cape_type_stats(cape_type:)
    usages = cape_type[:kills] + cape_type[:deaths] + cape_type[:assists]
    {
      name: cape_type[:name],
      kills: cape_type[:kills],
      deaths: cape_type[:deaths],
      assists: cape_type[:assists],
      usages:,
      total_ip: cape_type[:total_ip],
      avg_ip:
        begin
          cape_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          (100.0 / (cape_type[:kills] + cape_type[:deaths]) * (cape_type[:kills] * 100)).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
