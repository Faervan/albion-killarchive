# frozen_string_literal: true

require 'test_helper'

class FoodTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_FOOD_TYPE_PATH = 'MEAL_ROAST_FISH'
  FIRST_FOOD_TYPE_KILLS = 4
  FIRST_FOOD_TYPE_DEATHS = 2
  FIRST_FOOD_TYPE_ASSISTS = 2

  UNIQUE_FOOD_TYPES = 8

  HANDLER = EventHandlerService::ItemTypeHandlerService::FoodTypeHandlerService

  setup do
    HANDLER.new.handle_food_types(event_list: EVENT_LIST)
    HANDLER.new.handle_food_types(event_list: EVENT_LIST)
  end

  test "Unique food_type count is #{UNIQUE_FOOD_TYPES}" do
    assert_difference 'FoodType.count', 0 do
      HANDLER.new.handle_food_types(event_list: EVENT_LIST)
    end
    assert_equal UNIQUE_FOOD_TYPES, FoodType.count
  end

  test "Stats of types #{FIRST_FOOD_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_FOOD_TYPE_KILLS, FoodType.find_by(path: FIRST_FOOD_TYPE_PATH).kills
    assert_equal FIRST_FOOD_TYPE_DEATHS, FoodType.find_by(path: FIRST_FOOD_TYPE_PATH).deaths
    assert_equal FIRST_FOOD_TYPE_ASSISTS, FoodType.find_by(path: FIRST_FOOD_TYPE_PATH).assists
  end
end
