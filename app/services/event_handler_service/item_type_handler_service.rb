# frozen_string_literal: true

class String
  def parse_main_hand_type
    match = match(/T[1-8](?:_)?(?<double>2H_)?(?<item_type>[^@]*)(?:@[0-4])?/)
    path = match[:double].present? ? "2H_#{match[:item_type]}" : match[:item_type]
    {
      two_handed: match[:double].present?,
      path:
    }
  end

  def parse_mount_type
    match(/(?:T[1-8])?(?:_)?(?:2H_)?(?<item_name>[^@]*)(?:@[0-4])?/)[:item_name]
  end

  def parse_item_type
    match(/T[1-8](?:_)?(?:2H_)?(?<item_name>[^@]*)(?:@[0-4])?/)[:item_name]
  end
end

class EventHandlerService::ItemTypeHandlerService
  def handle_item_types(event_list:)
    MainHandTypeHandlerService.new.handle_main_hand_types(event_list:)
    OffHandTypeHandlerService.new.handle_off_hand_types(event_list:)
    HeadTypeHandlerService.new.handle_head_types(event_list:)
    ChestTypeHandlerService.new.handle_chest_types(event_list:)
    FeetTypeHandlerService.new.handle_feet_types(event_list:)
    CapeTypeHandlerService.new.handle_cape_types(event_list:)
    PotionTypeHandlerService.new.handle_potion_types(event_list:)
    FoodTypeHandlerService.new.handle_food_types(event_list:)
    MountTypeHandlerService.new.handle_mount_types(event_list:)
  end
end
