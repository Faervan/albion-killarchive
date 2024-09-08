# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::ComsumableHandlerService
  def initialize(item_slot:)
    @item_slot_model = item_slot
    @item_type_model = "#{item_slot}Type".constantize
    @item_slot_name = item_slot.to_s.parse_item_slot
  end

  def handle_consumables(event_list:)
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
    item = entity['Equipment'][@item_slot_name]
    parsed_item = item['Type'].parse_item
    {
      path: parsed_item[:path],
      item_type: item['Type'].parse_item_type[:path],
      tier: parsed_item[:tier],
      enchantment: parsed_item[:enchantment],
      total_ip: 0,
      kill_count: 0,
      death_count: 0,
      assist_count: 0
    }
  end

  def item_exists?(entity:)
    !entity['Equipment'][@item_slot_name].nil?
  end

  def update_items(items:, event_list:)
    event_list.each do |event|
      update_kill_count_and_ip(items:, event:)
      update_death_count_and_ip(items:, event:)
      update_assist_count_and_ip(items:, event:)
    end
  end

  def update_kill_count_and_ip(items:, event:)
    return unless item_exists?(entity: event['Killer'])

    item = find_item(items:, entity: event['Killer'])
    item[:kill_count] += 1
    item[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_death_count_and_ip(items:, event:)
    return unless item_exists?(entity: event['Victim'])

    item = find_item(items:, entity: event['Victim'])
    item[:death_count] += 1
    item[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assist_count_and_ip(items:, event:)
    event['Participants'].each do |participant|
      next if !item_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      item = find_item(items:, entity: participant)
      item[:assist_count] += 1
      item[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_item(items:, entity:)
    items.detect { |a| a[:path] == entity['Equipment'][@item_slot_name]['Type'].parse_item[:path] }
  end

  def persist_items(items:)
    items.each do |item|
      @item_slot_model.create!(
        set_item_stats(item:).merge({
          path: item[:path],
          item_type: item[:item_type],
          tier: item[:tier],
          enchantment: item[:enchantment]
        })
      )
      ItemFetcherJob.perform_later(
        path: "T#{item[:tier]}_#{item[:item_type]}",
        model: @item_slot_model,
        quality: 1,
        enchantment: item[:enchantment],
        with_name: true,
        is_consumable: true
      )
    rescue ActiveRecord::RecordNotUnique
      update_existing_item(item:)
    end
  end

  def update_existing_item(item:)
    existing_item = @item_slot_model.find_by(path: item[:path])
    item[:kill_count] += existing_item.kill_count
    item[:death_count] += existing_item.death_count
    item[:assist_count] += existing_item.assist_count
    item[:total_ip] += existing_item.total_ip
    existing_item.update(
      set_item_stats(item:)
    )
  end

  def set_item_stats(item:)
    usage_count = item[:kill_count] + item[:death_count] + item[:assist_count]
    {
      kill_count: item[:kill_count],
      death_count: item[:death_count],
      assist_count: item[:assist_count],
      usage_count:,
      total_ip: item[:total_ip],
      avg_ip: usage_count.positive? ? item[:total_ip] / usage_count : nil,
      kd_perc:
        begin
          (100.0 / (item[:kill_count] + item[:death_count]) * item[:kill_count] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          nil
        end
    }
  end
end
