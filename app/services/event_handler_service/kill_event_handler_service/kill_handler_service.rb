# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService::KillHandlerService
  def handle_kill(event:)
    equipment = event['Killer']['Equipment']
    Kill.create!(
      {
        kill_event_id: event['EventId'],
        player_id: event['Killer']['Id'],
        build_id: EventHandlerService::KillEventHandlerService.new.find_build(equipment:).id,
        awakened_weapon_id: event.dig('Killer', 'Equipment', 'MainHand', 'LegendarySoul', 'id')
      }.merge(EventHandlerService::KillEventHandlerService.new.find_items(equipment:))
    )
  end
end
