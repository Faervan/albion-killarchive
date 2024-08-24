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
  def handle_item_types(event_list:)
    [MainHandType, OffHandType, HeadType, ChestType, FeetType].each do |type|
      NormalTypeHandlerService
        .new(item_type: type)
        .handle_normal_types(event_list:)
    end
    [CapeType, PotionType, FoodType].each do |type|
      NoBaseIpTypeHandlerService
        .new(item_type: type)
        .handle_no_base_ip_types(event_list:)
    end
    [BagType, MountType].each do |type|
      BagAndMountTypeHandlerService
        .new(item_type: type)
        .handle_bag_and_mount_types(event_list:)
    end
  end

  def handle_items(event_list:)
    [MainHand, OffHand, Head, Chest, Feet, Bag, Cape, Mount].each do |type|
      NonComsumableHandlerService
        .new(item_slot: type)
        .handle_non_consumables(event_list:)
    end
    [Potion, Food].each do |type|
      ComsumableHandlerService
        .new(item_slot: type)
        .handle_consumables(event_list:)
    end
  end
end
