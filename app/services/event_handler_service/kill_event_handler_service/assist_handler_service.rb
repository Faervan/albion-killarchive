# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService::AssistHandlerService
  def handle_assists(event:)
    event['Participants'].reject { |p| p['Id'] == event['Killer']['Id'] }.each do |participant|
      persist_assist(participant:, event:)
    end
    event['GroupMembers'].reject { |a| event['Participants'].pluck('Id').include? a['Id'] }.each do |passive_ally|
      persist_passive(passive_ally:, event:)
    end
  end

  private

  def persist_assist(participant:, event:)
    equipment = participant['Equipment']
    allies_entry = event['GroupMembers'].detect { |a| a['Id'] == participant['Id'] }
    Assist.create!(
      {
        kill_event_id: event['EventId'],
        player_id: participant['Id'],
        build_id: EventHandlerService::KillEventHandlerService.new.find_build(equipment:).id,
        awakened_weapon_id: participant.dig('Equipment', 'MainHand', 'LegendarySoul', 'id'),
        avg_ip: participant['AverageItemPower'].round,
        kill_fame: allies_entry&.[]('KillFame').to_i,
        damage: participant['DamageDone'].to_i,
        healing: participant['SupportHealingDone'].to_i,
        ally?: !allies_entry.nil?
      }.merge(EventHandlerService::KillEventHandlerService.new.find_items(equipment:))
    )
  end

  def persist_passive(passive_ally:, event:)
    PassiveAssist.create!(
      {
        kill_event_id: event['EventId'],
        player_id: passive_ally['Id'],
        main_hand_path: EventHandlerService::KillEventHandlerService
                        .new.find_item(equipment: passive_ally['Equipment'], item: MainHand),
        awakened_weapon_id: passive_ally.dig('Equipment', 'MainHand', 'LegendarySoul', 'id'),
        kill_fame: passive_ally['KillFame']
      }
    )
  end
end
