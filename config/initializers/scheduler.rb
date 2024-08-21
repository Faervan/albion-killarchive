# frozen_string_literal: true

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.in '4s' do
  # EventFetcherJob.perform_later
end

scheduler.every '60s' do
  EventFetcherJob.perform_later
end
