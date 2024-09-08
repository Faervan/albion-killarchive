# frozen_string_literal: true

require 'test_helper'

class NormalTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  MAIN_HAND_TYPE = {
    path: '2H_DUALSWORD',
    two_handed: true,
    kill_count: 0,
    death_count: 2,
    assist_count: 2,
    count: 34
  }.freeze
  OFF_HAND_TYPE = {
    path: 'OFF_JESTERCANE_HELL',
    kill_count: 2,
    death_count: 2,
    assist_count: 2,
    count: 6
  }.freeze
  HEAD_TYPE = {
    path: 'HEAD_LEATHER_SET2',
    kill_count: 4,
    death_count: 8,
    assist_count: 0,
    count: 19
  }.freeze
  CHEST_TYPE = {
    path: 'ARMOR_LEATHER_SET2',
    kill_count: 4,
    death_count: 4,
    assist_count: 0,
    count: 14
  }.freeze
  FEET_TYPE = {
    path: 'SHOES_CLOTH_AVALON',
    kill_count: 6,
    death_count: 2,
    assist_count: 0,
    count: 18
  }.freeze

  ALL_TYPES = [MAIN_HAND_TYPE, OFF_HAND_TYPE, HEAD_TYPE, CHEST_TYPE, FEET_TYPE].freeze
  ALL_TYPE_MODELS = [MainHandType, OffHandType, HeadType, ChestType, FeetType].freeze
  HANDLER = EventHandlerService::ItemHandlerService::NormalTypeHandlerService

  setup do
    ALL_TYPE_MODELS.each do |model|
      HANDLER.new(item_type: model).handle_normal_types(event_list: EVENT_LIST)
      HANDLER.new(item_type: model).handle_normal_types(event_list: EVENT_LIST)
    end
  end

  test 'Unique normal type count is correct' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      assert_difference 'type.count', 0 do
        HANDLER.new(item_type: model).handle_normal_types(event_list: EVENT_LIST)
      end
      assert_equal type[:count], model.count
    end
  end

  test 'Stats of normal types correctly saved to database' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      obj = model.find_by(path: type[:path])
      assert_equal type[:two_handed], obj.two_handed? if model == MainHandType
      assert_equal type[:kill_count], obj.kill_count
      assert_equal type[:death_count], obj.death_count
      assert_equal type[:assist_count], obj.assist_count
    end
  end
end
