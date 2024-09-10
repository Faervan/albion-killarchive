# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService::KillHandlerService
  def handle_kill(event:)
    equipment = event['Killer']['Equipment']
    participant_entry = event['Participants'].detect { |p| p['Id'] == event['Killer']['Id'] }
    Kill.create!(
      {
        kill_event_id: event['EventId'],
        player_id: event['Killer']['Id'],
        build_id: EventHandlerService::KillEventHandlerService.new.find_build(equipment:).id,
        awakened_weapon_id: event.dig('Killer', 'Equipment', 'MainHand', 'LegendarySoul', 'id'),
        avg_ip: event['Killer']['AverageItemPower'].round,
        kill_fame: event['Killer']['KillFame'],
        damage: participant_entry&.[]('DamageDone').to_i,
        healing: participant_entry&.[]('SupportHealingDone').to_i
      }.merge(EventHandlerService::KillEventHandlerService.new.find_items(equipment:))
    )
  end
end
