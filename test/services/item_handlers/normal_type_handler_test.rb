# frozen_string_literal: true

require 'test_helper'

class NormalTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  MAIN_HAND_TYPE = {
    path: '2H_DUALSWORD',
    two_handed: true,
    kills: 0,
    deaths: 2,
    assists: 2,
    count: 34
  }.freeze
  OFF_HAND_TYPE = {
    path: 'OFF_JESTERCANE_HELL',
    kills: 2,
    deaths: 2,
    assists: 2,
    count: 6
  }.freeze
  HEAD_TYPE = {
    path: 'HEAD_LEATHER_SET2',
    kills: 4,
    deaths: 8,
    assists: 0,
    count: 19
  }.freeze
  CHEST_TYPE = {
    path: 'ARMOR_LEATHER_SET2',
    kills: 4,
    deaths: 4,
    assists: 0,
    count: 14
  }.freeze
  FEET_TYPE = {
    path: 'SHOES_CLOTH_AVALON',
    kills: 6,
    deaths: 2,
    assists: 0,
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
      assert_equal type[:two_handed], model.find_by(path: type[:path]).two_handed? if model == MainHandType
      assert_equal type[:kills], model.find_by(path: type[:path]).kills
      assert_equal type[:deaths], model.find_by(path: type[:path]).deaths
      assert_equal type[:assists], model.find_by(path: type[:path]).assists
    end
  end
end
