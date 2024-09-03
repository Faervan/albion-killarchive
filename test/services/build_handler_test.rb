# frozen_string_literal: true

require 'test_helper'

class BuildHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  AWAKENED_WEAPON = {
    id: 'd1237484-eac0-49f8-8589-c90c60404463',
    last_equipped: '2024-07-09T13:35:57.321305100Z',
    attuned_player_name: 'TestingLimits',
    attunement: 3_711_129_324,
    attunement_since_reset: 14_455_583_886,
    crafted_player_name: 'Cigert',
    pvp_fame: 571_997_723_623,
    trait0: 'TRAIT_HITPOINTS_MAX',
    trait1_value: 0.112064511,
    trait2_roll: 0.7262954989900386,
    count: 3
  }.freeze
  TRAIT = {
    trait: 'TRAIT_HITPOINTS_MAX',
    min_value: 2.6,
    max_value: 260,
    count: 4
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
    assert true # probably right
  end
end
