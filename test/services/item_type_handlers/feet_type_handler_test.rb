# frozen_string_literal: true

require 'test_helper'

class FeetTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_FEET_TYPE_PATH = 'SHOES_PLATE_SET3'
  FIRST_FEET_TYPE_KILLS = 4
  FIRST_FEET_TYPE_DEATHS = 4
  FIRST_FEET_TYPE_ASSISTS = 0
  SECOND_FEET_TYPE_PATH = 'SHOES_CLOTH_AVALON'
  SECOND_FEET_TYPE_KILLS = 6
  SECOND_FEET_TYPE_DEATHS = 2
  SECOND_FEET_TYPE_ASSISTS = 0

  UNIQUE_FEET_TYPES = 18

  HANDLER = EventHandlerService::ItemTypeHandlerService::FeetTypeHandlerService

  setup do
    HANDLER.new.handle_feet_types(event_list: EVENT_LIST)
    HANDLER.new.handle_feet_types(event_list: EVENT_LIST)
  end

  test "Unique feet_type count is #{UNIQUE_FEET_TYPES}" do
    assert_difference 'FeetType.count', 0 do
      HANDLER.new.handle_feet_types(event_list: EVENT_LIST)
    end
    assert_equal FeetType.count, UNIQUE_FEET_TYPES
  end

  test "Stats of types #{FIRST_FEET_TYPE_PATH} and #{SECOND_FEET_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_FEET_TYPE_KILLS, FeetType.find_by(path: FIRST_FEET_TYPE_PATH).kills
    assert_equal FIRST_FEET_TYPE_DEATHS, FeetType.find_by(path: FIRST_FEET_TYPE_PATH).deaths
    assert_equal FIRST_FEET_TYPE_ASSISTS, FeetType.find_by(path: FIRST_FEET_TYPE_PATH).assists
    assert_equal SECOND_FEET_TYPE_KILLS, FeetType.find_by(path: SECOND_FEET_TYPE_PATH).kills
    assert_equal SECOND_FEET_TYPE_DEATHS, FeetType.find_by(path: SECOND_FEET_TYPE_PATH).deaths
    assert_equal SECOND_FEET_TYPE_ASSISTS, FeetType.find_by(path: SECOND_FEET_TYPE_PATH).assists
  end
end
