# frozen_string_literal: true

require 'test_helper'

class BuildHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  BUILD = {
    main_hand_type: '2H_DUALAXE_KEEPER',
    off_hand_type: nil,
    head_type: 'HEAD_CLOTH_HELL',
    chest_type: 'ARMOR_LEATHER_SET3',
    feet_type: 'SHOES_CLOTH_ROYAL',
    cape_type: 'CAPEITEM_FW_THETFORD',
    kill_count: 2,
    death_count: 0,
    assist_count: 1,
    kill_fame: 83_976,
    death_fame: 0,
    avg_ip_diff: 264
  }.freeze

  HANDLER = EventHandlerService::BuildHandlerService

  setup do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    EventHandlerService::AvatarHandlerService.new.handle_avatars(event_list: EVENT_LIST)
    EventHandlerService::AvatarRingHandlerService.new.handle_avatar_rings(event_list: EVENT_LIST)
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)

    [MainHandType, OffHandType, HeadType, ChestType, FeetType].each do |model|
      EventHandlerService::ItemHandlerService::NormalTypeHandlerService
        .new(item_type: model).handle_normal_types(event_list: EVENT_LIST)
    end
    EventHandlerService::ItemHandlerService::NoBaseIpTypeHandlerService
      .new(item_type: CapeType).handle_no_base_ip_types(event_list: EVENT_LIST)
    [MainHand, OffHand, Head, Chest, Feet, Cape].each do |model|
      EventHandlerService::ItemHandlerService::NonComsumableHandlerService
        .new(item_slot: model).handle_non_consumables(event_list: EVENT_LIST)
    end

    HANDLER.new.handle_builds(event_list: EVENT_LIST)
    HANDLER.new.handle_builds(event_list: EVENT_LIST)
  end

  test 'Unique build count is correct' do
    assert_difference 'Build.count', 0 do
      HANDLER.new.handle_builds(event_list: EVENT_LIST)
    end
  end

  test 'Stats of builds correctly saved to database' do
    build = Build.find_by(get_build_key(build: BUILD))
    assert_equal BUILD[:kill_count] * 2, build.kill_count
    assert_equal BUILD[:death_count] * 2, build.death_count
    assert_equal BUILD[:assist_count] * 2, build.assist_count
    assert_equal BUILD[:kill_fame] * 2, build.kill_fame
    assert_equal BUILD[:death_fame] * 2, build.death_fame
    assert_equal BUILD[:avg_ip_diff], build.avg_ip_diff
  end

  private

  def get_build_key(build:)
    {
      main_hand_type: MainHandType.find_by(path: build[:main_hand_type]),
      off_hand_type: OffHandType.find_by(path: build[:off_hand_type]),
      head_type: HeadType.find_by(path: build[:head_type]),
      chest_type: ChestType.find_by(path: build[:chest_type]),
      feet_type: FeetType.find_by(path: build[:feet_type]),
      cape_type: CapeType.find_by(path: build[:cape_type])
    }
  end
end
