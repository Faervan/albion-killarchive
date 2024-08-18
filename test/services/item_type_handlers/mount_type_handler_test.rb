# frozen_string_literal: true

require 'test_helper'

class MountTypeHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_MOUNT_TYPE_PATH = 'MOUNT_DIREBOAR_FW_LYMHURST'
  FIRST_MOUNT_TYPE_USAGES = 4
  SECOND_MOUNT_TYPE_PATH = 'UNIQUE_MOUNT_MORGANA_RAVEN_ADC'
  SECOND_MOUNT_TYPE_USAGES = 4

  UNIQUE_MOUNT_TYPES = 10

  HANDLER = EventHandlerService::ItemTypeHandlerService::MountTypeHandlerService

  setup do
    HANDLER.new.handle_mount_types(event_list: EVENT_LIST)
    HANDLER.new.handle_mount_types(event_list: EVENT_LIST)
  end

  test "Unique mount_type count is #{UNIQUE_MOUNT_TYPES}" do
    assert_difference 'MountType.count', 0 do
      HANDLER.new.handle_mount_types(event_list: EVENT_LIST)
    end
    assert_equal MountType.count, UNIQUE_MOUNT_TYPES
  end

  test "Stats of types #{FIRST_MOUNT_TYPE_PATH} and #{SECOND_MOUNT_TYPE_PATH} correctly saved to database" do
    assert_equal FIRST_MOUNT_TYPE_USAGES, MountType.find_by(path: FIRST_MOUNT_TYPE_PATH).usages
    assert_equal SECOND_MOUNT_TYPE_USAGES, MountType.find_by(path: SECOND_MOUNT_TYPE_PATH).usages
  end
end
