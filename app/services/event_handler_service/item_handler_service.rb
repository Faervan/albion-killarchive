# frozen_string_literal: true

class String
  def parse_item
    match = match(/(?<tier>T[1-8]_)?(?:2H_)?(?:[^@]*)(?<enchantment>@[0-4])?/)
    {
      path: self,
      tier: match[:tier],
      enchantment: match[:enchantment]
    }
  end

  def parse_item_type
    match = match(/(?:T[1-8]_)?(?<double>2H_)?(?<item_type>[^@]*)(?:@[0-4])?/)
    {
      two_handed: match[:double].present?,
      path: (match[:double] || '') + match[:item_type]
    }
  end

  def parse_item_slot
    case self
    when 'Chest'
      'Armor'
    when 'Feet'
      'Shoes'
    else
      self
    end
  end
end

class EventHandlerService::ItemHandlerService
  def handle_items(event_list:)
    [MainHand, OffHand, Head, Chest, Feet, Bag, Cape, Mount].each do |type|
      EventHandlerService::ItemHandlerService::NonComsumableHandlerService
        .new(item_slot: type)
        .handle_non_consumables(event_list:)
    end
    [Potion, Food].each do |type|
      EventHandlerService::ItemHandlerService::ComsumableHandlerService
        .new(item_slot: type)
        .handle_consumables(event_list:)
    end
  end
end
