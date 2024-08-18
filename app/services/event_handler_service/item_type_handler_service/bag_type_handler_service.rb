# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::BagTypeHandlerService
  def handle_bag_types(event_list:)
    bag_types = build_bag_types(event_list:)
    update_bag_types(bag_types:, event_list:)
    persist_bag_types(bag_types:)
  end

  private

  def build_bag_types(event_list:)
    bag_types = event_list.flat_map do |event|
      build_bag_type_objects(event:)
    end
    bag_types.uniq
  end

  def build_bag_type_objects(event:)
    objects = []
    objects << build_bag_type_object(entity: event['Killer']) if bag_exists?(entity: event['Killer'])
    objects << build_bag_type_object(entity: event['Victim']) if bag_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_bag_type_object(entity: participant) if bag_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_bag_type_object(entity: member) if bag_exists?(entity: member)
    end
    objects
  end

  def build_bag_type_object(entity:)
    {
      name: entity['Equipment']['Bag']['Type'].parse_item_type,
      path: entity['Equipment']['Bag']['Type'].parse_item_type,
      usages: 0
    }
  end

  def bag_exists?(entity:)
    !entity['Equipment']['Bag'].nil?
  end

  def update_bag_types(bag_types:, event_list:)
    event_list.each do |event|
      update_kills(bag_types:, event:)
      update_deaths(bag_types:, event:)
      update_assists(bag_types:, event:)
    end
  end

  def update_kills(bag_types:, event:)
    return unless bag_exists?(entity: event['Killer'])

    bag_type = find_bag_type(bag_types:, entity: event['Killer'])
    bag_type[:usages] += 1
  end

  def update_deaths(bag_types:, event:)
    return unless bag_exists?(entity: event['Victim'])

    bag_type = find_bag_type(bag_types:, entity: event['Victim'])
    bag_type[:usages] += 1
  end

  def update_assists(bag_types:, event:)
    event['Participants'].each do |participant|
      next if !bag_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      bag_type = find_bag_type(bag_types:, entity: participant)
      bag_type[:usages] += 1
    end
  end

  def find_bag_type(bag_types:, entity:)
    bag_types.detect { |a| a[:path] == entity['Equipment']['Bag']['Type'].parse_item_type }
  end

  def persist_bag_types(bag_types:)
    bag_types.each do |bag_type|
      next if bag_type[:path] == ''

      persist_bag_type(bag_type:)
    end
  end

  def persist_bag_type(bag_type:)
    BagType.create!(
      set_bag_type_stats(bag_type:).merge({ path: bag_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_bag_type(bag_type:)
  end

  def update_existing_bag_type(bag_type:)
    existing_bag_type = BagType.find_by(path: bag_type[:path])
    bag_type[:usages] += existing_bag_type.usages
    existing_bag_type.update(
      set_bag_type_stats(bag_type:)
    )
  end

  def set_bag_type_stats(bag_type:)
    {
      name: bag_type[:name],
      usages: bag_type[:usages]
    }
  end
end
