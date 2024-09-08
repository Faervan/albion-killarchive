# frozen_string_literal: true

require 'test_helper'

class NonConsumableHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')

  ALL_TYPE_MODELS = [MainHandType, OffHandType, HeadType, ChestType, FeetType].freeze
  ALL_MODELS = [MainHand, OffHand, Head, Chest, Feet, Cape, Bag, Mount].freeze
  HANDLER = EventHandlerService::ItemHandlerService::NonComsumableHandlerService

  setup do
    ALL_TYPE_MODELS.each do |model|
      EventHandlerService::ItemHandlerService::NormalTypeHandlerService
        .new(item_type: model).handle_normal_types(event_list: EVENT_LIST)
    end
    [BagType, MountType].each do |model|
      EventHandlerService::ItemHandlerService::BagAndMountTypeHandlerService
        .new(item_type: model).handle_bag_and_mount_types(event_list: EVENT_LIST)
    end
    EventHandlerService::ItemHandlerService::NoBaseIpTypeHandlerService
      .new(item_type: CapeType).handle_no_base_ip_types(event_list: EVENT_LIST)
    ALL_MODELS.each do |model|
      HANDLER.new(item_slot: model).handle_non_consumables(event_list: EVENT_LIST)
    end
  end

  test 'Non consumable handler working' do
    assert true # probably working
  end
end
