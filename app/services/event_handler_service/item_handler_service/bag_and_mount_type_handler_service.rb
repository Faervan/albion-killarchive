# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::BagAndMountTypeHandlerService
  def initialize(item_type:)
    @item_type_model = item_type
    @item_type_name = item_type.to_s.chomp('Type')
  end

  def handle_bag_and_mount_types(event_list:)
    item_types = build_item_types(event_list:)
    update_item_types(item_types:, event_list:)
    persist_item_types(item_types:)
  end

  private

  def build_item_types(event_list:)
    item_types = event_list.flat_map do |event|
      build_item_type_objects(event:)
    end
    item_types.uniq
  end

  def build_item_type_objects(event:)
    objects = []
    objects << build_item_type_object(entity: event['Killer']) if bag_exists?(entity: event['Killer'])
    objects << build_item_type_object(entity: event['Victim']) if bag_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_item_type_object(entity: participant) if bag_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_item_type_object(entity: member) if bag_exists?(entity: member)
    end
    objects
  end

  def build_item_type_object(entity:)
    {
      path: entity['Equipment'][@item_type_name]['Type'].parse_item_type[:path],
      usages: 0,
      total_ip: 0
    }
  end

  def bag_exists?(entity:)
    !entity['Equipment'][@item_type_name].nil?
  end

  def update_item_types(item_types:, event_list:)
    event_list.each do |event|
      update_kills(item_types:, event:)
      update_deaths(item_types:, event:)
      update_assists(item_types:, event:)
    end
  end

  def update_kills(item_types:, event:)
    return unless bag_exists?(entity: event['Killer'])

    item_type = find_item_type(item_types:, entity: event['Killer'])
    item_type[:usages] += 1
    item_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths(item_types:, event:)
    return unless bag_exists?(entity: event['Victim'])

    item_type = find_item_type(item_types:, entity: event['Victim'])
    item_type[:usages] += 1
    item_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists(item_types:, event:)
    event['Participants'].each do |participant|
      next if !bag_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      item_type = find_item_type(item_types:, entity: participant)
      item_type[:usages] += 1
      item_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_item_type(item_types:, entity:)
    item_types.detect { |a| a[:path] == entity['Equipment'][@item_type_name]['Type'].parse_item_type[:path] }
  end

  def persist_item_types(item_types:)
    item_types.each do |item_type|
      next if item_type[:path] == ''

      persist_item_type(item_type:)
    end
  end

  def persist_item_type(item_type:)
    @item_type_model.create!(
      set_item_type_stats(item_type:).merge({ path: item_type[:path] })
    )
    ItemFetcherJob.perform_later(
      path: "T8_#{item_type[:path]}",
      model: "#{@item_type_name}Type".constantize,
      quality: 4,
      enchantment: 0
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_item_type(item_type:)
  end

  def update_existing_item_type(item_type:)
    existing_item_type = @item_type_model.find_by(path: item_type[:path])
    item_type[:usages] += existing_item_type.usages
    item_type[:total_ip] += existing_item_type.total_ip
    existing_item_type.update(
      set_item_type_stats(item_type:)
    )
  end

  def set_item_type_stats(item_type:)
    {
      usages: item_type[:usages],
      total_ip: item_type[:total_ip],
      avg_ip: item_type[:total_ip] / item_type[:usages]
    }
  end
end
