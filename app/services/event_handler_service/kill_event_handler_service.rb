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
      total_fame: 108_240,
      assists: event['Participants'].count - 1,
      allies: event['GroupMembers'].count - 1,
      passive_assists: get_passive_assist_count(assists: event['Participants'], allies: event['GroupMembers'])
    )
  end

  def get_passive_assist_count(assists:, allies:)
    allies.reject { |ally| assists.any? { |a| a['Id'] == ally['Id'] } }.count
  end
end
