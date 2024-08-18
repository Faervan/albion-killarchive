# frozen_string_literal: true

require 'test_helper'

class MainHandTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_MAIN_HAND_TYPE_PATH = 'MAIN_FIRESTAFF_KEEPER'
  FIRST_MAIN_HAND_TYPE_KILLS = 0
  FIRST_MAIN_HAND_TYPE_DEATHS = 4
  FIRST_MAIN_HAND_TYPE_ASSISTS = 2
  SECOND_MAIN_HAND_TYPE_PATH = 'MAIN_DAGGER'
  SECOND_MAIN_HAND_TYPE_KILLS = 4
  SECOND_MAIN_HAND_TYPE_DEATHS = 4
  SECOND_MAIN_HAND_TYPE_ASSISTS = 0

  UNIQUE_MAIN_HAND_TYPES = 34

  HANDLER = EventHandlerService::ItemTypeHandlerService::MainHandTypeHandlerService

  setup do
    HANDLER.new.handle_main_hand_types(event_list: EVENT_LIST)
    HANDLER.new.handle_main_hand_types(event_list: EVENT_LIST)
  end

  test "Unique main_hand_type count is #{MainHandType.count}" do
    assert_difference 'MainHandType.count', 0 do
      HANDLER.new.handle_main_hand_types(event_list: EVENT_LIST)
    end
    assert_equal UNIQUE_MAIN_HAND_TYPES, MainHandType.count
  end

  test "Stats of types #{FIRST_MAIN_HAND_TYPE_PATH} and #{SECOND_MAIN_HAND_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_MAIN_HAND_TYPE_KILLS, MainHandType.find_by(path: FIRST_MAIN_HAND_TYPE_PATH).kills
    assert_equal FIRST_MAIN_HAND_TYPE_DEATHS, MainHandType.find_by(path: FIRST_MAIN_HAND_TYPE_PATH).deaths
    assert_equal FIRST_MAIN_HAND_TYPE_ASSISTS, MainHandType.find_by(path: FIRST_MAIN_HAND_TYPE_PATH).assists
    assert_equal SECOND_MAIN_HAND_TYPE_KILLS, MainHandType.find_by(path: SECOND_MAIN_HAND_TYPE_PATH).kills
    assert_equal SECOND_MAIN_HAND_TYPE_DEATHS, MainHandType.find_by(path: SECOND_MAIN_HAND_TYPE_PATH).deaths
    assert_equal SECOND_MAIN_HAND_TYPE_ASSISTS, MainHandType.find_by(path: SECOND_MAIN_HAND_TYPE_PATH).assists
  end
end
