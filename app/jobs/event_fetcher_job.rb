# frozen_string_literal: true

class EventFetcherJob < ApplicationJob
  self.log_arguments = false
  LAST_API_EVENTS_SHASUM_FILE_PATH = Rails.root.join('tmp/last_api_events_shasum')

  queue_as :default

  def perform
    offset = 0
    event_list = []
    while (result = query_events(offset)) && result[:more]
      event_list += result[:new_events]
      offset += 50
      break if offset > 1000
    end
    destroy_expired_events
    EventHandlerService.new.persist_events(event_list)
  end

  private

  def query_events(offset)
    event_list = HTTParty.get("https://gameinfo-ams.albiononline.com/api/gameinfo/events?limit=50&offset=#{offset}")
    new_events = []
    event_list.each do |event|
      FetchedEvent.create!(event_id: event['EventId'], expires_at: 60.minutes.from_now)
      new_events << event
    rescue ActiveRecord::RecordNotUnique
      return { new_events:, more: false }
    end
    { new_events:, more: true }
  end

  def destroy_expired_events
    FetchedEvent.expired.destroy_all
  end
end
