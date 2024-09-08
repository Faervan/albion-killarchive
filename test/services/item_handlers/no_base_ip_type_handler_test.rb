# frozen_string_literal: true

require 'test_helper'

class NoBaseIpTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  CAPE_TYPE = {
    path: 'CAPEITEM_FW_THETFORD',
    kill_count: 10,
    death_count: 4,
    assist_count: 2,
    count: 13
  }.freeze
  POTION_TYPE = {
    path: 'POTION_ENERGY',
    kill_count: 0,
    death_count: 2,
    assist_count: 2,
    count: 6
  }.freeze
  FOOD_TYPE = {
    path: 'MEAL_ROAST_FISH',
    kill_count: 4,
    death_count: 2,
    assist_count: 2,
    count: 8
  }.freeze

  ALL_TYPES = [CAPE_TYPE, POTION_TYPE, FOOD_TYPE].freeze
  ALL_TYPE_MODELS = [CapeType, PotionType, FoodType].freeze
  HANDLER = EventHandlerService::ItemHandlerService::NoBaseIpTypeHandlerService

  setup do
    ALL_TYPES.each_with_index do |_type, index|
      model = ALL_TYPE_MODELS[index]
      HANDLER.new(item_type: model).handle_no_base_ip_types(event_list: EVENT_LIST)
      HANDLER.new(item_type: model).handle_no_base_ip_types(event_list: EVENT_LIST)
    end
  end

  test 'Unique no_base_ip type count is correct' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      assert_difference 'type.count', 0 do
        HANDLER.new(item_type: model).handle_no_base_ip_types(event_list: EVENT_LIST)
      end
      assert_equal type[:count], model.count
    end
  end

  test 'Stats of normal types correctly saved to database' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      assert_equal type[:kill_count], model.find_by(path: type[:path]).kill_count
      assert_equal type[:death_count], model.find_by(path: type[:path]).death_count
      assert_equal type[:assist_count], model.find_by(path: type[:path]).assist_count
    end
  end
end
