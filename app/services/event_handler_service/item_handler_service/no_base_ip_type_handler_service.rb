# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::NoBaseIpTypeHandlerService
  def initialize(item_type:)
    @item_type_model = item_type
    @item_type_name = item_type.to_s.chomp('Type')
  end

  def handle_no_base_ip_types(event_list:)
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
    {
      path: entity['Equipment'][@item_type_name]['Type'].parse_item_type[:path],
      total_ip: 0,
      kill_count: 0,
      death_count: 0,
      assist_count: 0,
      usage_count: 0
    }
  end

  def item_exists?(entity:)
    !entity['Equipment'][@item_type_name].nil?
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
    items.detect { |a| a[:path] == entity['Equipment'][@item_type_name]['Type'].parse_item_type[:path] }
  end

  def persist_items(items:)
    items.each do |item|
      @item_type_model.create!(
        set_item_stats(item:).merge({
          path: item[:path]
        })
      )
      if @item_type_model == CapeType
        ItemFetcherJob.perform_later(
          path: "T8_#{item[:path]}",
          model: @item_type_name.constantize,
          quality: 4,
          enchantment: 0
        )
        ItemTypeNameFetcherJob.perform_later(model: @item_type_model, path: item[:path])
      end
    rescue ActiveRecord::RecordNotUnique
      update_existing_item(item:)
    end
  end

  def update_existing_item(item:)
    existing_item = @item_type_model.find_by(path: item[:path])
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
