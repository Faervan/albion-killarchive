# frozen_string_literal: true

require 'test_helper'

class PlayerHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_PLAYER_NAME = '1StepAhead'
  FIRST_PLAYER_ID = 'v7WWkqR5QPed98qGh9eA6A'
  FIRST_PLAYER_TOTAL_KILL_FAME = 75_216
  FIRST_PLAYER_TOTAL_KILL_COUNT = 0
  FIRST_PLAYER_TOTAL_ASSIST_COUNT = 4
  SECOND_PLAYER_NAME = 'BLDGO'
  SECOND_PLAYER_ID = 'br8Az7QUQ72LqTyPbBZgQw'
  SECOND_PLAYER_TOTAL_DEATH_FAME = 20_454
  SECOND_PLAYER_TOTAL_DEATH_COUNT = 2
  SECOND_PLAYER_TOTAL_ASSIST_COUNT = 0

  setup do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    EventHandlerService::AvatarHandlerService.new.handle_avatars(event_list: EVENT_LIST)
    EventHandlerService::AvatarRingHandlerService.new.handle_avatar_rings(event_list: EVENT_LIST)
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
  end

  test 'Unique player count is 74' do
    assert_difference 'Player.count', 74 do
      EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    end
  end

  test 'First event\'s data correctly saved to database' do
    player = Player.find_by(player_id: FIRST_PLAYER_ID)
    assert_equal FIRST_PLAYER_NAME, player.name
  end

  test "Stats of players #{FIRST_PLAYER_NAME} and #{SECOND_PLAYER_NAME} correctly saved to database" do
    assert_equal FIRST_PLAYER_TOTAL_KILL_FAME, Player.find_by(name: FIRST_PLAYER_NAME).total_kill_fame
    assert_equal FIRST_PLAYER_TOTAL_KILL_COUNT, Player.find_by(name: FIRST_PLAYER_NAME).total_kill_count
    assert_equal FIRST_PLAYER_TOTAL_ASSIST_COUNT, Player.find_by(name: FIRST_PLAYER_NAME).total_assist_count
    assert_equal SECOND_PLAYER_TOTAL_DEATH_FAME, Player.find_by(name: SECOND_PLAYER_NAME).total_death_fame
    assert_equal SECOND_PLAYER_TOTAL_DEATH_COUNT, Player.find_by(name: SECOND_PLAYER_NAME).total_death_count
    assert_equal SECOND_PLAYER_TOTAL_ASSIST_COUNT, Player.find_by(name: SECOND_PLAYER_NAME).total_assist_count
  end
end
