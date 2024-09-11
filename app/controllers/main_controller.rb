# frozen_string_literal: true

class MainController < ApplicationController
  def index
    @fetched_events = CachedEvent.count
    @last_event_update = CachedEvent.order(:expires_at).last.try(:expires_at)
                                    .try { |time| time - 60.minutes }.try(:utc).try(:iso8601)
    @last_query = File.read('tmp/time_since_last_query').chomp.to_datetime.utc.iso8601
  end
end
