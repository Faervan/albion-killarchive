# frozen_string_literal: true

require 'test_helper'

class BagAndMountTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  BAG_TYPE = {
    path: 'BAG_INSIGHT',
    usage_count: 10,
    count: 2
  }.freeze
  MOUNT_TYPE = {
    path: 'UNIQUE_MOUNT_MORGANA_RAVEN_ADC',
    usage_count: 4,
    count: 10
  }.freeze

  ALL_TYPES = [BAG_TYPE, MOUNT_TYPE].freeze
  ALL_TYPE_MODELS = [BagType, MountType].freeze
  HANDLER = EventHandlerService::ItemHandlerService::BagAndMountTypeHandlerService

  setup do
    ALL_TYPES.each_with_index do |_type, index|
      model = ALL_TYPE_MODELS[index]
      HANDLER.new(item_type: model).handle_bag_and_mount_types(event_list: EVENT_LIST)
      HANDLER.new(item_type: model).handle_bag_and_mount_types(event_list: EVENT_LIST)
    end
  end

  test 'Unique bag_and_mount type count is correct' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      assert_difference 'type.count', 0 do
        HANDLER.new(item_type: model).handle_bag_and_mount_types(event_list: EVENT_LIST)
      end
      assert_equal type[:count], model.count
    end
  end

  test 'Stats of normal types correctly saved to database' do
    ALL_TYPES.each_with_index do |type, index|
      model = ALL_TYPE_MODELS[index]
      assert_equal type[:usage_count], model.find_by(path: type[:path]).usage_count
    end
  end
end
