# frozen_string_literal: true

class MainController < ApplicationController
  def index
    @fetched_events = CachedEvent.count
    @last_event_update = (CachedEvent.order(:expires_at).last.expires_at - 60.minutes).utc.iso8601
  end
end
