# frozen_string_literal: true

require 'test_helper'

class PotionTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_POTION_TYPE_PATH = 'POTION_ENERGY'
  FIRST_POTION_TYPE_KILLS = 0
  FIRST_POTION_TYPE_DEATHS = 2
  FIRST_POTION_TYPE_ASSISTS = 2

  UNIQUE_POTION_TYPES = 6

  HANDLER = EventHandlerService::ItemTypeHandlerService::PotionTypeHandlerService

  setup do
    HANDLER.new.handle_potion_types(event_list: EVENT_LIST)
    HANDLER.new.handle_potion_types(event_list: EVENT_LIST)
  end

  test "Unique potion_type count is #{UNIQUE_POTION_TYPES}" do
    assert_difference 'PotionType.count', 0 do
      HANDLER.new.handle_potion_types(event_list: EVENT_LIST)
    end
    assert_equal PotionType.count, UNIQUE_POTION_TYPES
  end

  test "Stats of type #{FIRST_POTION_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_POTION_TYPE_KILLS, PotionType.find_by(path: FIRST_POTION_TYPE_PATH).kills
    assert_equal FIRST_POTION_TYPE_DEATHS, PotionType.find_by(path: FIRST_POTION_TYPE_PATH).deaths
    assert_equal FIRST_POTION_TYPE_ASSISTS, PotionType.find_by(path: FIRST_POTION_TYPE_PATH).assists
  end
end
