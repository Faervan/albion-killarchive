# frozen_string_literal: true

require 'test_helper'

class BagTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  SECOND_BAG_TYPE_PATH = 'BAG_INSIGHT'
  SECOND_BAG_TYPE_USAGES = 10

  UNIQUE_BAG_TYPES = 2

  HANDLER = EventHandlerService::ItemTypeHandlerService::BagTypeHandlerService

  setup do
    HANDLER.new.handle_bag_types(event_list: EVENT_LIST)
    HANDLER.new.handle_bag_types(event_list: EVENT_LIST)
  end

  test "Unique bag_type count is #{UNIQUE_BAG_TYPES}" do
    assert_difference 'BagType.count', 0 do
      HANDLER.new.handle_bag_types(event_list: EVENT_LIST)
    end
    assert_equal BagType.count, UNIQUE_BAG_TYPES
  end

  test "Stats of type #{SECOND_BAG_TYPE_PATH} correctly saved to database" do
    assert_equal SECOND_BAG_TYPE_USAGES, BagType.find_by(path: SECOND_BAG_TYPE_PATH).usages
  end
end
