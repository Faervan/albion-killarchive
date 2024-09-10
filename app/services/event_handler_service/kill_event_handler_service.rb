# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService
  def handle_kill_events(event_list:)
    event_list.each do |event|
      persist_kill_event(event:)
      KillHandlerService.new.handle_kill(event:)
      DeathHandlerService.new.handle_death(event:)
      AssistHandlerService.new.handle_assists(event:)
    end
  end

  def find_build(equipment:)
    Build.find_by(
      main_hand_type: get_equipment_type(equipment:, type: 'MainHand'),
      off_hand_type: get_equipment_type(equipment:, type: 'OffHand'),
      head_type: get_equipment_type(equipment:, type: 'Head'),
      chest_type: get_equipment_type(equipment:, type: 'Armor'),
      feet_type: get_equipment_type(equipment:, type: 'Shoes'),
      cape_type: get_equipment_type(equipment:, type: 'Cape')
    )
  end

  def find_items(equipment:)
    {
      main_hand_path: find_item(equipment:, item: MainHand),
      off_hand_path: find_item(equipment:, item: OffHand),
      head_path: find_item(equipment:, item: Head),
      chest_path: find_item(equipment:, item: Chest),
      feet_path: find_item(equipment:, item: Feet),
      cape_path: find_item(equipment:, item: Cape),
      bag_path: find_item(equipment:, item: Bag),
      mount_path: find_item(equipment:, item: Mount),
      potion_path: find_item(equipment:, item: Potion),
      food_path: find_item(equipment:, item: Food)
    }
  end

  def find_item(equipment:, item:)
    item_name = item.model_name.name.parse_item_slot
    quality = [Potion, Food].include?(item) ? '' : "_Q#{equipment[item_name]&.[]('Quality')}"
    item_path = equipment[item_name]&.[]('Type')&.parse_item&.[](:path)
    item_path ? "#{item_path}#{quality}" : nil
  end

  private

  def persist_kill_event(event:)
    KillEvent.create!(
      kill_event_id: event['EventId'],
      timestamp: event['TimeStamp'].to_datetime.utc,
      total_fame: event['TotalVictimKillFame'],
      assist_count: get_assist_count(assists: event['Participants'], killer_id: event['Killer']['Id']),
      ally_count: get_ally_count(allies: event['GroupMembers'], killer_id: event['Killer']['Id']),
      passive_assist_count: get_passive_assist_count(assists: event['Participants'], allies: event['GroupMembers'])
    )
  end

  def get_assist_count(assists:, killer_id:)
    assists.reject { |assist| assist['Id'] == killer_id }.count
  end

  def get_ally_count(allies:, killer_id:)
    allies.reject { |ally| ally['Id'] == killer_id }.count
  end

  def get_passive_assist_count(assists:, allies:)
    allies.reject { |ally| assists.any? { |a| a['Id'] == ally['Id'] } }.count
  end

  def get_equipment_type(equipment:, type:)
    equipment.dig(type, 'Type')&.parse_item_type&.[](:path)
  end
end
