# frozen_string_literal: true

require 'test_helper'

class OffHandTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_OFF_HAND_TYPE_PATH = 'OFF_TORCH'
  FIRST_OFF_HAND_TYPE_KILLS = 2
  FIRST_OFF_HAND_TYPE_DEATHS = 8
  FIRST_OFF_HAND_TYPE_ASSISTS = 0
  SECOND_OFF_HAND_TYPE_PATH = 'OFF_JESTERCANE_HELL'
  SECOND_OFF_HAND_TYPE_KILLS = 2
  SECOND_OFF_HAND_TYPE_DEATHS = 2
  SECOND_OFF_HAND_TYPE_ASSISTS = 2

  UNIQUE_OFF_HAND_TYPES = 6

  HANDLER = EventHandlerService::ItemTypeHandlerService::OffHandTypeHandlerService

  setup do
    HANDLER.new.handle_off_hand_types(event_list: EVENT_LIST)
    HANDLER.new.handle_off_hand_types(event_list: EVENT_LIST)
  end

  test "Unique off_hand_type count is #{UNIQUE_OFF_HAND_TYPES}" do
    assert_difference 'OffHandType.count', 0 do
      HANDLER.new.handle_off_hand_types(event_list: EVENT_LIST)
    end
    assert_equal OffHandType.count, UNIQUE_OFF_HAND_TYPES
  end

  test "Stats of types #{FIRST_OFF_HAND_TYPE_PATH} and #{SECOND_OFF_HAND_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_OFF_HAND_TYPE_KILLS, OffHandType.find_by(path: FIRST_OFF_HAND_TYPE_PATH).kills
    assert_equal FIRST_OFF_HAND_TYPE_DEATHS, OffHandType.find_by(path: FIRST_OFF_HAND_TYPE_PATH).deaths
    assert_equal FIRST_OFF_HAND_TYPE_ASSISTS, OffHandType.find_by(path: FIRST_OFF_HAND_TYPE_PATH).assists
    assert_equal SECOND_OFF_HAND_TYPE_KILLS, OffHandType.find_by(path: SECOND_OFF_HAND_TYPE_PATH).kills
    assert_equal SECOND_OFF_HAND_TYPE_DEATHS, OffHandType.find_by(path: SECOND_OFF_HAND_TYPE_PATH).deaths
    assert_equal SECOND_OFF_HAND_TYPE_ASSISTS, OffHandType.find_by(path: SECOND_OFF_HAND_TYPE_PATH).assists
  end
end
