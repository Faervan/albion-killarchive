# frozen_string_literal: true

require 'test_helper'

class AvatarRingHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_AVATAR_RING = 'AVATARRING_ADC_MAY2019'
  SECOND_AVATAR_RING = 'AVATARRING_ADC_JUL2019'
  NOT_SAVED_AVATAR_RING = 'AVATARRING_ADC_FEB2019'

  setup do
    EventHandlerService::AvatarRingHandlerService.new.handle_avatar_rings(event_list: EVENT_LIST)
  end

  test 'AvatarRings saved to database' do
    assert AvatarRing.find_by(avatar_ring_id: FIRST_AVATAR_RING)
    assert AvatarRing.find_by(avatar_ring_id: SECOND_AVATAR_RING)
  end

  test 'AvatarRing not saved to database' do
    assert_not AvatarRing.find_by(avatar_ring_id: NOT_SAVED_AVATAR_RING)
  end
end
