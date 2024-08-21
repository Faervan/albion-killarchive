# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::MountTypeHandlerService
  def handle_mount_types(event_list:)
    mount_types = build_mount_types(event_list:)
    update_mount_types(mount_types:, event_list:)
    persist_mount_types(mount_types:)
  end

  private

  def build_mount_types(event_list:)
    mount_types = event_list.flat_map do |event|
      build_mount_type_objects(event:)
    end
    mount_types.uniq
  end

  def build_mount_type_objects(event:)
    objects = []
    objects << build_mount_type_object(entity: event['Killer']) if mount_exists?(entity: event['Killer'])
    objects << build_mount_type_object(entity: event['Victim']) if mount_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_mount_type_object(entity: participant) if mount_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_mount_type_object(entity: member) if mount_exists?(entity: member)
    end
    objects
  end

  def build_mount_type_object(entity:)
    {
      path: entity['Equipment']['Mount']['Type'].parse_mount_type,
      total_ip: 0,
      usages: 0
    }
  end

  def mount_exists?(entity:)
    !entity['Equipment']['Mount'].nil?
  end

  def update_mount_types(mount_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(mount_types:, event:)
      update_deaths_and_ip(mount_types:, event:)
      update_assists_and_ip(mount_types:, event:)
    end
  end

  def update_kills_and_ip(mount_types:, event:)
    return unless mount_exists?(entity: event['Killer'])

    mount_type = find_mount_type(mount_types:, entity: event['Killer'])
    mount_type[:usages] += 1
    mount_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(mount_types:, event:)
    return unless mount_exists?(entity: event['Victim'])

    mount_type = find_mount_type(mount_types:, entity: event['Victim'])
    mount_type[:usages] += 1
    mount_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(mount_types:, event:)
    event['Participants'].each do |participant|
      next if !mount_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      mount_type = find_mount_type(mount_types:, entity: participant)
      mount_type[:usages] += 1
      mount_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_mount_type(mount_types:, entity:)
    mount_types.detect { |a| a[:path] == entity['Equipment']['Mount']['Type'].parse_mount_type }
  end

  def persist_mount_types(mount_types:)
    mount_types.each do |mount_type|
      next if mount_type[:path] == ''

      persist_mount_type(mount_type:)
    end
  end

  def persist_mount_type(mount_type:)
    MountType.create!(
      set_mount_type_stats(mount_type:).merge({ path: mount_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_mount_type(mount_type:)
  end

  def update_existing_mount_type(mount_type:)
    existing_mount_type = MountType.find_by(path: mount_type[:path])
    mount_type[:usages] += existing_mount_type.usages
    mount_type[:total_ip] += existing_mount_type.total_ip
    existing_mount_type.update(
      set_mount_type_stats(mount_type:)
    )
  end

  def set_mount_type_stats(mount_type:)
    {
      usages: mount_type[:usages],
      total_ip: mount_type[:total_ip],
      avg_ip:
        begin
          mount_type[:total_ip] / mount_type[:usages]
        rescue ZeroDivisionError
          0
        end
    }
  end
end
