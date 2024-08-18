# frozen_string_literal: true

require 'test_helper'

class CapeTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_CAPE_TYPE_PATH = 'CAPEITEM_FW_THETFORD'
  FIRST_CAPE_TYPE_KILLS = 10
  FIRST_CAPE_TYPE_DEATHS = 4
  FIRST_CAPE_TYPE_ASSISTS = 2
  SECOND_CAPE_TYPE_PATH = 'CAPEITEM_DEMON'
  SECOND_CAPE_TYPE_KILLS = 4
  SECOND_CAPE_TYPE_DEATHS = 0
  SECOND_CAPE_TYPE_ASSISTS = 4

  UNIQUE_CAPE_TYPES = 13

  HANDLER = EventHandlerService::ItemTypeHandlerService::CapeTypeHandlerService

  setup do
    HANDLER.new.handle_cape_types(event_list: EVENT_LIST)
    HANDLER.new.handle_cape_types(event_list: EVENT_LIST)
  end

  test "Unique cape_type count is #{UNIQUE_CAPE_TYPES}" do
    assert_difference 'CapeType.count', 0 do
      HANDLER.new.handle_cape_types(event_list: EVENT_LIST)
    end
    assert_equal CapeType.count, UNIQUE_CAPE_TYPES
  end

  test "Stats of types #{FIRST_CAPE_TYPE_PATH} and #{SECOND_CAPE_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_CAPE_TYPE_KILLS, CapeType.find_by(path: FIRST_CAPE_TYPE_PATH).kills
    assert_equal FIRST_CAPE_TYPE_DEATHS, CapeType.find_by(path: FIRST_CAPE_TYPE_PATH).deaths
    assert_equal FIRST_CAPE_TYPE_ASSISTS, CapeType.find_by(path: FIRST_CAPE_TYPE_PATH).assists
    assert_equal SECOND_CAPE_TYPE_KILLS, CapeType.find_by(path: SECOND_CAPE_TYPE_PATH).kills
    assert_equal SECOND_CAPE_TYPE_DEATHS, CapeType.find_by(path: SECOND_CAPE_TYPE_PATH).deaths
    assert_equal SECOND_CAPE_TYPE_ASSISTS, CapeType.find_by(path: SECOND_CAPE_TYPE_PATH).assists
  end
end
