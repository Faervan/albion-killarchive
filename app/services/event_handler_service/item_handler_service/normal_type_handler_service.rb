# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::NormalTypeHandlerService
  def initialize(item_type:)
    @item_type_model = item_type
    @item_type_name = item_type.to_s.chomp('Type').parse_item_slot
    @item_slot_model = item_type.to_s.chomp('Type').constantize
  end

  def handle_normal_types(event_list:)
    items = build_items(event_list:)
    update_items(items:, event_list:)
    persist_items(items:)
  end

  private

  def build_items(event_list:)
    items = event_list.flat_map do |event|
      build_item_objects(event:)
    end
    items.uniq
  end

  def build_item_objects(event:)
    objects = []
    objects << build_item_object(entity: event['Killer']) if item_exists?(entity: event['Killer'])
    objects << build_item_object(entity: event['Victim']) if item_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_item_object(entity: participant) if item_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_item_object(entity: member) if item_exists?(entity: member)
    end
    objects
  end

  def build_item_object(entity:)
    parsed_type = entity['Equipment'][@item_type_name]['Type'].parse_item_type
    {
      path: parsed_type[:path],
      two_handed: parsed_type[:two_handed],
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0,
      usages: 0,
      base_ip: 0
    }
  end

  def item_exists?(entity:)
    !entity['Equipment'][@item_type_name].nil?
  end

  def update_items(items:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(items:, event:)
      update_deaths_and_ip(items:, event:)
      update_assists_and_ip(items:, event:)
    end
  end

  def update_kills_and_ip(items:, event:)
    return unless item_exists?(entity: event['Killer'])

    item = find_item(items:, entity: event['Killer'])
    item[:kills] += 1
    item[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(items:, event:)
    return unless item_exists?(entity: event['Victim'])

    item = find_item(items:, entity: event['Victim'])
    item[:deaths] += 1
    item[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(items:, event:)
    event['Participants'].each do |participant|
      next if !item_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      item = find_item(items:, entity: participant)
      item[:assists] += 1
      item[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_item(items:, entity:)
    items.detect { |a| a[:path] == entity['Equipment'][@item_type_name]['Type'].parse_item_type[:path] }
  end

  def persist_items(items:)
    items.each do |item|
      @item_type_model.create!(
        set_item_stats(item:).merge({ path: item[:path] }).merge(
          item[:two_handed] ? { two_handed?: item[:two_handed] } : {}
        )
      )
      ItemFetcherJob.perform_later(
        path: "T8_#{item[:path]}",
        model: @item_slot_model,
        quality: 4,
        enchantment: 0,
        with_base_ip: true
      )
      ItemTypeNameFetcherJob.perform_later(model: @item_type_model, path: item[:path])
    rescue ActiveRecord::RecordNotUnique
      update_existing_item(item:)
    end
  end

  def update_existing_item(item:)
    existing_item = @item_type_model.find_by(path: item[:path])
    item[:kills] += existing_item.kills
    item[:deaths] += existing_item.deaths
    item[:assists] += existing_item.assists
    item[:total_ip] += existing_item.total_ip
    existing_item.update(
      set_item_stats(item:)
    )
  end

  def set_item_stats(item:)
    usages = item[:kills] + item[:deaths] + item[:assists]
    {
      kills: item[:kills],
      deaths: item[:deaths],
      assists: item[:assists],
      usages:,
      total_ip: item[:total_ip],
      avg_ip: usages.positive? ? item[:total_ip] / usages : nil,
      kd_perc:
        begin
          (100.0 / (item[:kills] + item[:deaths]) * item[:kills] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          nil
        end
    }
  end
end
