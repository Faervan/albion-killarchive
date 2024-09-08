# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService::DeathHandlerService
  def handle_death(event:)
    equipment = event['Victim']['Equipment']
    Death.create!(
      {
        kill_event_id: event['EventId'],
        player_id: event['Victim']['Id'],
        build_id: EventHandlerService::KillEventHandlerService.new.find_build(equipment:).id,
        awakened_weapon_id: event.dig('Victim', 'Equipment', 'MainHand', 'LegendarySoul', 'id')
      }.merge(EventHandlerService::KillEventHandlerService.new.find_items(equipment:))
    )
  end
end
