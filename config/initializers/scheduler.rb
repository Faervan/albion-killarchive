# frozen_string_literal: true

require 'rufus-scheduler'

FileUtils.touch('tmp/time_since_last_query') unless File.exist?('tmp/time_since_last_query')

scheduler = Rufus::Scheduler.new

scheduler.in '4s' do
  EventFetcherJob.perform_later(full_query: true)
end

scheduler.every '60s' do
  EventFetcherJob.perform_later
end

scheduler.every '10m' do
  EventFetcherJob.perform_later(full_query: true)
end
