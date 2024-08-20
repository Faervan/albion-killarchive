# frozen_string_literal: true

class EventFetcherJob < ApplicationJob
  self.log_arguments = false
  queue_as :default

  def perform
    offset = 0
    event_list = []
    while (result = query_events(offset:)) && result[:more]
      event_list += result[:new_events]
      offset += 50
      break if offset > 1000
    end
    destroy_expired_events
    EventHandlerService.new.persist_events(event_list)
  end

  private

  def query_events(offset:)
    event_list = HTTParty.get("https://gameinfo-ams.albiononline.com/api/gameinfo/events?limit=50&offset=#{offset}")
    new_events = []
    event_list.each do |event|
      FetchedEvent.create!(event_id: event['EventId'], expires_at: 60.minutes.from_now)
      new_events << event
    rescue ActiveRecord::RecordNotUnique
      next
    end
    { new_events:, more: new_events.count.positive? }
  end

  def destroy_expired_events
    FetchedEvent.expired.destroy_all
  end
end
