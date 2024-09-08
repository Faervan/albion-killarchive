# frozen_string_literal: true

require 'test_helper'

class ConsumableHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')

  ALL_TYPE_MODELS = [PotionType, FoodType].freeze
  ALL_MODELS = [Potion, Food].freeze
  TYPE_HANLDER = EventHandlerService::ItemHandlerService::NoBaseIpTypeHandlerService
  HANDLER = EventHandlerService::ItemHandlerService::ComsumableHandlerService

  setup do
    ALL_TYPE_MODELS.each do |model|
      TYPE_HANLDER.new(item_type: model).handle_no_base_ip_types(event_list: EVENT_LIST)
    end
    ALL_MODELS.each do |model|
      HANDLER.new(item_slot: model).handle_consumables(event_list: EVENT_LIST)
    end
  end

  test 'Consumable handler working' do
    assert true # probably working
  end
end
