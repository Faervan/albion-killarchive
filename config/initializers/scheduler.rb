# frozen_string_literal: true

require 'rufus-scheduler'

FileUtils.touch('tmp/time_since_last_query') unless File.exist?('tmp/time_since_last_query')

scheduler = Rufus::Scheduler.new

unless ENV['NO_EVENT_FETCH'] == 'true'
  scheduler.in '4s' do
    EventFetcherJob.perform_later(full_query: true)
  end

  scheduler.every '60s' do
    EventFetcherJob.perform_later
  end

  scheduler.every '5m' do
    EventFetcherJob.perform_later(full_query: true)
  end
end
