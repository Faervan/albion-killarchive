# frozen_string_literal: true

require 'test_helper'

class PlayerHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_PLAYER_NAME = 'Die Schwarzen Engel'
  FIRST_PLAYER_ID = '-0Pu27dRRKCYS6aTh1fgug'
  FIRST_PLAYER_TOTAL_KILL_FAME = 162_360
  FIRST_PLAYER_TOTAL_KILL_COUNT = 2
  FIRST_PLAYER_TOTAL_ASSIST_COUNT = 2
  SECOND_PLAYER_NAME = 'Error404'
  SECOND_PLAYER_ID = 'UCLmBccEQ4W6kksAWwxMXA'
  SECOND_PLAYER_TOTAL_DEATH_FAME = 216_480
  SECOND_PLAYER_TOTAL_DEATH_COUNT = 2
  SECOND_PLAYER_TOTAL_ASSIST_COUNT = 0

  setup do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
  end

  test 'Unique player count is 37' do
    assert_difference 'Player.count', 37 do
      EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
      EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    end
  end

  test 'First event\'s data correctly saved to database' do
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    assert_equal SECOND_PLAYER_ID, Player.first.player_id
    assert_equal SECOND_PLAYER_NAME, Player.first.name
  end

  test "Stats of players #{FIRST_PLAYER_NAME} and #{SECOND_PLAYER_NAME} correctly saved to database" do
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    assert_equal FIRST_PLAYER_TOTAL_KILL_FAME, Player.find_by(name: FIRST_PLAYER_NAME).total_kill_fame
    assert_equal FIRST_PLAYER_TOTAL_KILL_COUNT, Player.find_by(name: FIRST_PLAYER_NAME).total_kill_count
    assert_equal FIRST_PLAYER_TOTAL_ASSIST_COUNT, Player.find_by(name: FIRST_PLAYER_NAME).total_assist_count
    assert_equal SECOND_PLAYER_TOTAL_DEATH_FAME, Player.find_by(name: SECOND_PLAYER_NAME).total_death_fame
    assert_equal SECOND_PLAYER_TOTAL_DEATH_COUNT, Player.find_by(name: SECOND_PLAYER_NAME).total_death_count
    assert_equal SECOND_PLAYER_TOTAL_ASSIST_COUNT, Player.find_by(name: SECOND_PLAYER_NAME).total_assist_count
  end
end
