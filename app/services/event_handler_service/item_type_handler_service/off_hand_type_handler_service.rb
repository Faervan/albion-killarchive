# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::OffHandTypeHandlerService
  def handle_off_hand_types(event_list:)
    off_hand_types = build_off_hand_types(event_list:)
    update_off_hand_types(off_hand_types:, event_list:)
    persist_off_hand_types(off_hand_types:)
  end

  private

  def build_off_hand_types(event_list:)
    off_hand_types = event_list.flat_map do |event|
      build_off_hand_type_objects(event:)
    end
    off_hand_types.uniq
  end

  def build_off_hand_type_objects(event:)
    objects = []
    objects << build_off_hand_type_object(entity: event['Killer']) if off_hand_exists?(entity: event['Killer'])
    objects << build_off_hand_type_object(entity: event['Victim']) if off_hand_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_off_hand_type_object(entity: participant) if off_hand_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_off_hand_type_object(entity: member) if off_hand_exists?(entity: member)
    end
    objects
  end

  def build_off_hand_type_object(entity:)
    {
      name: entity['Equipment']['OffHand']['Type'].parse_item_type,
      path: entity['Equipment']['OffHand']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def off_hand_exists?(entity:)
    !entity['Equipment']['OffHand'].nil?
  end

  def update_off_hand_types(off_hand_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(off_hand_types:, event:)
      update_deaths_and_ip(off_hand_types:, event:)
      update_assists_and_ip(off_hand_types:, event:)
    end
  end

  def update_kills_and_ip(off_hand_types:, event:)
    return unless off_hand_exists?(entity: event['Killer'])

    off_hand_type = find_off_hand_type(off_hand_types:, entity: event['Killer'])
    off_hand_type[:kills] += 1
    off_hand_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(off_hand_types:, event:)
    return unless off_hand_exists?(entity: event['Victim'])

    off_hand_type = find_off_hand_type(off_hand_types:, entity: event['Victim'])
    off_hand_type[:deaths] += 1
    off_hand_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(off_hand_types:, event:)
    event['Participants'].each do |participant|
      next if !off_hand_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      off_hand_type = find_off_hand_type(off_hand_types:, entity: participant)
      off_hand_type[:assists] += 1
      off_hand_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_off_hand_type(off_hand_types:, entity:)
    off_hand_types.detect { |a| a[:path] == entity['Equipment']['OffHand']['Type'].parse_item_type }
  end

  def persist_off_hand_types(off_hand_types:)
    off_hand_types.each do |off_hand_type|
      next if off_hand_type[:path] == ''

      persist_off_hand_type(off_hand_type:)
    end
  end

  def persist_off_hand_type(off_hand_type:)
    OffHandType.create!(
      set_off_hand_type_stats(off_hand_type:).merge({ path: off_hand_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_off_hand_type(off_hand_type:)
  end

  def update_existing_off_hand_type(off_hand_type:)
    existing_off_hand_type = OffHandType.find_by(path: off_hand_type[:path])
    off_hand_type[:kills] += existing_off_hand_type.kills
    off_hand_type[:deaths] += existing_off_hand_type.deaths
    off_hand_type[:assists] += existing_off_hand_type.assists
    off_hand_type[:total_ip] += existing_off_hand_type.total_ip
    existing_off_hand_type.update(
      set_off_hand_type_stats(off_hand_type:)
    )
  end

  def set_off_hand_type_stats(off_hand_type:)
    usages = off_hand_type[:kills] + off_hand_type[:deaths] + off_hand_type[:assists]
    {
      name: off_hand_type[:name],
      kills: off_hand_type[:kills],
      deaths: off_hand_type[:deaths],
      assists: off_hand_type[:assists],
      usages:,
      total_ip: off_hand_type[:total_ip],
      avg_ip:
        begin
          off_hand_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          100 / (off_hand_type[:kills] + off_hand_type[:deaths]) * (off_hand_type[:kills] * 100)
        rescue ZeroDivisionError
          0
        end
    }
  end
end
