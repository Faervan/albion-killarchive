# frozen_string_literal: true

class EventFetcherJob < ApplicationJob
  self.log_arguments = false
  LAST_API_EVENTS_SHASUM_FILE_PATH = Rails.root.join('tmp/last_api_events_shasum')

  queue_as :default

  def perform
    event_list = HTTParty.get('https://gameinfo-ams.albiononline.com/api/gameinfo/events').body
    new_events_shasum = Digest::SHA2.hexdigest event_list
    last_events_shasum = File.read LAST_API_EVENTS_SHASUM_FILE_PATH

    return if new_events_shasum == last_events_shasum

    File.write LAST_API_EVENTS_SHASUM_FILE_PATH, new_events_shasum
    EventHandlerService.new.persist_events JSON.parse(event_list)
  end
end
