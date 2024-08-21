# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::HeadTypeHandlerService
  def handle_head_types(event_list:)
    head_types = build_head_types(event_list:)
    update_head_types(head_types:, event_list:)
    persist_head_types(head_types:)
  end

  private

  def build_head_types(event_list:)
    head_types = event_list.flat_map do |event|
      build_head_type_objects(event:)
    end
    head_types.uniq
  end

  def build_head_type_objects(event:)
    objects = []
    objects << build_head_type_object(entity: event['Killer']) if head_exists?(entity: event['Killer'])
    objects << build_head_type_object(entity: event['Victim']) if head_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_head_type_object(entity: participant) if head_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_head_type_object(entity: member) if head_exists?(entity: member)
    end
    objects
  end

  def build_head_type_object(entity:)
    {
      path: entity['Equipment']['Head']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def head_exists?(entity:)
    !entity['Equipment']['Head'].nil?
  end

  def update_head_types(head_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(head_types:, event:)
      update_deaths_and_ip(head_types:, event:)
      update_assists_and_ip(head_types:, event:)
    end
  end

  def update_kills_and_ip(head_types:, event:)
    return unless head_exists?(entity: event['Killer'])

    head_type = find_head_type(head_types:, entity: event['Killer'])
    head_type[:kills] += 1
    head_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(head_types:, event:)
    return unless head_exists?(entity: event['Victim'])

    head_type = find_head_type(head_types:, entity: event['Victim'])
    head_type[:deaths] += 1
    head_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(head_types:, event:)
    event['Participants'].each do |participant|
      next if !head_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      head_type = find_head_type(head_types:, entity: participant)
      head_type[:assists] += 1
      head_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_head_type(head_types:, entity:)
    head_types.detect { |a| a[:path] == entity['Equipment']['Head']['Type'].parse_item_type }
  end

  def persist_head_types(head_types:)
    head_types.each do |head_type|
      next if head_type[:path] == ''

      persist_head_type(head_type:)
    end
  end

  def persist_head_type(head_type:)
    HeadType.create!(
      set_head_type_stats(head_type:).merge({ path: head_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_head_type(head_type:)
  end

  def update_existing_head_type(head_type:)
    existing_head_type = HeadType.find_by(path: head_type[:path])
    head_type[:kills] += existing_head_type.kills
    head_type[:deaths] += existing_head_type.deaths
    head_type[:assists] += existing_head_type.assists
    head_type[:total_ip] += existing_head_type.total_ip
    existing_head_type.update(
      set_head_type_stats(head_type:)
    )
  end

  def set_head_type_stats(head_type:)
    usages = head_type[:kills] + head_type[:deaths] + head_type[:assists]
    {
      kills: head_type[:kills],
      deaths: head_type[:deaths],
      assists: head_type[:assists],
      usages:,
      total_ip: head_type[:total_ip],
      avg_ip:
        begin
          head_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          (100.0 / (head_type[:kills] + head_type[:deaths]) * head_type[:kills] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
