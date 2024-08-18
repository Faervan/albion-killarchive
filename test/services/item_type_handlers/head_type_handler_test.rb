# frozen_string_literal: true

require 'test_helper'

class HeadTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_HEAD_TYPE_PATH = 'HEAD_LEATHER_SET2'
  FIRST_HEAD_TYPE_KILLS = 4
  FIRST_HEAD_TYPE_DEATHS = 8
  FIRST_HEAD_TYPE_ASSISTS = 0
  SECOND_HEAD_TYPE_PATH = 'HEAD_CLOTH_SET3'
  SECOND_HEAD_TYPE_KILLS = 2
  SECOND_HEAD_TYPE_DEATHS = 2
  SECOND_HEAD_TYPE_ASSISTS = 2

  UNIQUE_HEAD_TYPES = 19

  HANDLER = EventHandlerService::ItemTypeHandlerService::HeadTypeHandlerService

  setup do
    HANDLER.new.handle_head_types(event_list: EVENT_LIST)
    HANDLER.new.handle_head_types(event_list: EVENT_LIST)
  end

  test "Unique head_type count is #{UNIQUE_HEAD_TYPES}" do
    assert_difference 'HeadType.count', 0 do
      HANDLER.new.handle_head_types(event_list: EVENT_LIST)
    end
    assert_equal HeadType.count, UNIQUE_HEAD_TYPES
  end

  test "Stats of types #{FIRST_HEAD_TYPE_PATH} and #{SECOND_HEAD_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_HEAD_TYPE_KILLS, HeadType.find_by(path: FIRST_HEAD_TYPE_PATH).kills
    assert_equal FIRST_HEAD_TYPE_DEATHS, HeadType.find_by(path: FIRST_HEAD_TYPE_PATH).deaths
    assert_equal FIRST_HEAD_TYPE_ASSISTS, HeadType.find_by(path: FIRST_HEAD_TYPE_PATH).assists
    assert_equal SECOND_HEAD_TYPE_KILLS, HeadType.find_by(path: SECOND_HEAD_TYPE_PATH).kills
    assert_equal SECOND_HEAD_TYPE_DEATHS, HeadType.find_by(path: SECOND_HEAD_TYPE_PATH).deaths
    assert_equal SECOND_HEAD_TYPE_ASSISTS, HeadType.find_by(path: SECOND_HEAD_TYPE_PATH).assists
  end
end
