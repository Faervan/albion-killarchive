# frozen_string_literal: true

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.in '4s' do
  EventFetcherJob.perform_later
end

scheduler.every '30s' do
  EventFetcherJob.perform_later
end
