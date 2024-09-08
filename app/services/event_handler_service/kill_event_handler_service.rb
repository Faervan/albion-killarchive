# frozen_string_literal: true

class EventHandlerService::KillEventHandlerService
  def handle_kill_events(event_list:)
    event_list.each do |event|
      persist_kill_event(event:)
      KillHandlerService.new.handle_kill(event:)
    end
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
end
