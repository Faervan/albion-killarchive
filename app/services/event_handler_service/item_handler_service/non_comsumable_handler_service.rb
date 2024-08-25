# frozen_string_literal: true

class EventHandlerService::ItemHandlerService::NonComsumableHandlerService
  def initialize(item_slot:)
    @item_slot_model = item_slot
    @item_type_model = "#{item_slot}Type".constantize
    @item_slot_name = item_slot.to_s.parse_item_slot
  end

  def handle_non_consumables(event_list:)
    items = build_items(event_list:)
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
      path: "#{parsed_item[:path]}_Q#{item['Quality']}",
      item_type: item['Type'].parse_item_type[:path],
      tier: parsed_item[:tier],
      enchantment: parsed_item[:enchantment],
      quality: item['Quality']
    }
  end

  def item_exists?(entity:)
    !entity['Equipment'][@item_slot_name].nil?
  end

  def persist_items(items:)
    items.each do |item|
      @item_slot_model.create!(item)
      ItemFetcherJob.perform_later(
        path: (item[:tier].positive? ? "T#{item[:tier]}_" : '') + item[:item_type],
        model: @item_slot_model,
        quality: item[:quality],
        enchantment: item[:enchantment],
        with_name: true
      )
    rescue ActiveRecord::RecordNotUnique
      next
    end
  end
end
