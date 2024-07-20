# frozen_string_literal: true

require 'test_helper'

class AllianceHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_ALLIANCE_NAME = 'BLACK'
  FIRST_ALLIANCE_ID = 'pK63yNuuQb-n91rFNderrA'
  FIRST_ALLIANCE_TOTAL_KILL_FAME = 216_480
  FIRST_ALLIANCE_TOTAL_KILL_COUNT = 2
  SECOND_ALLIANCE_NAME = '2v2'
  SECOND_ALLIANCE_ID = 'mdu0MX3jSYWfxBeSxSBx4g'
  SECOND_ALLIANCE_TOTAL_DEATH_FAME = 165_870
  SECOND_ALLIANCE_TOTAL_DEATH_COUNT = 2

  test 'Unique alliance count is 20' do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    assert_equal 20, Alliance.count
  end

  test 'First event\'s data correctly saved to database' do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    alliance = Alliance.find_by(alliance_id: 'pK63yNuuQb-n91rFNderrA')
    assert_equal FIRST_ALLIANCE_NAME, alliance.name
  end

  test "Stats of alliances #{FIRST_ALLIANCE_NAME} and #{SECOND_ALLIANCE_NAME} correctly saved to database" do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    assert_equal FIRST_ALLIANCE_TOTAL_KILL_FAME, Alliance.find_by(name: FIRST_ALLIANCE_NAME).total_kill_fame
    assert_equal FIRST_ALLIANCE_TOTAL_KILL_COUNT, Alliance.find_by(name: FIRST_ALLIANCE_NAME).total_kill_count
    assert_equal SECOND_ALLIANCE_TOTAL_DEATH_FAME, Alliance.find_by(name: SECOND_ALLIANCE_NAME).total_death_fame
    assert_equal SECOND_ALLIANCE_TOTAL_DEATH_COUNT, Alliance.find_by(name: SECOND_ALLIANCE_NAME).total_death_count
  end
end
