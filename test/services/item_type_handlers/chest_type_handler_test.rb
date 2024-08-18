# frozen_string_literal: true

require 'test_helper'

class ChestTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_CHEST_TYPE_PATH = 'ARMOR_LEATHER_SET1'
  FIRST_CHEST_TYPE_KILLS = 6
  FIRST_CHEST_TYPE_DEATHS = 8
  FIRST_CHEST_TYPE_ASSISTS = 2
  SECOND_CHEST_TYPE_PATH = 'ARMOR_LEATHER_SET2'
  SECOND_CHEST_TYPE_KILLS = 4
  SECOND_CHEST_TYPE_DEATHS = 4
  SECOND_CHEST_TYPE_ASSISTS = 0

  UNIQUE_CHEST_TYPES = 14

  HANDLER = EventHandlerService::ItemTypeHandlerService::ChestTypeHandlerService

  setup do
    HANDLER.new.handle_chest_types(event_list: EVENT_LIST)
    HANDLER.new.handle_chest_types(event_list: EVENT_LIST)
  end

  test "Unique chest_type count is #{UNIQUE_CHEST_TYPES}" do
    assert_difference 'ChestType.count', 0 do
      HANDLER.new.handle_chest_types(event_list: EVENT_LIST)
    end
    assert_equal ChestType.count, UNIQUE_CHEST_TYPES
  end

  test "Stats of types #{FIRST_CHEST_TYPE_PATH} and #{SECOND_CHEST_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_CHEST_TYPE_KILLS, ChestType.find_by(path: FIRST_CHEST_TYPE_PATH).kills
    assert_equal FIRST_CHEST_TYPE_DEATHS, ChestType.find_by(path: FIRST_CHEST_TYPE_PATH).deaths
    assert_equal FIRST_CHEST_TYPE_ASSISTS, ChestType.find_by(path: FIRST_CHEST_TYPE_PATH).assists
    assert_equal SECOND_CHEST_TYPE_KILLS, ChestType.find_by(path: SECOND_CHEST_TYPE_PATH).kills
    assert_equal SECOND_CHEST_TYPE_DEATHS, ChestType.find_by(path: SECOND_CHEST_TYPE_PATH).deaths
    assert_equal SECOND_CHEST_TYPE_ASSISTS, ChestType.find_by(path: SECOND_CHEST_TYPE_PATH).assists
  end
end
