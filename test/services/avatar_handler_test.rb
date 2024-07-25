# frozen_string_literal: true

require 'test_helper'

class AvatarHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_AVATAR = 'AVATAR_06'
  SECOND_AVATAR = 'AVATAR_08'
  NOT_SAVED_AVATAR = 'AVATAR_10'

  setup do
    EventHandlerService::AvatarHandlerService.new.handle_avatars(event_list: EVENT_LIST)
  end

  test 'Avatars saved to database' do
    assert Avatar.find_by(avatar_id: FIRST_AVATAR)
    assert Avatar.find_by(avatar_id: SECOND_AVATAR)
  end

  test 'Avatar not saved to database' do
    assert_not Avatar.find_by(avatar_id: NOT_SAVED_AVATAR)
  end
end
