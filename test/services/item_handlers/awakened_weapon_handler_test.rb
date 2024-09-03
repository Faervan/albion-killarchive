# frozen_string_literal: true

require 'test_helper'

class AwakenedWeaponHandlerTest < ActiveSupport::TestCase
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

  HANDLER = EventHandlerService::ItemHandlerService::AwakenedWeaponHandlerService

  setup do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    EventHandlerService::AvatarHandlerService.new.handle_avatars(event_list: EVENT_LIST)
    EventHandlerService::AvatarRingHandlerService.new.handle_avatar_rings(event_list: EVENT_LIST)
    EventHandlerService::PlayerHandlerService.new.handle_players(event_list: EVENT_LIST)
    EventHandlerService::ItemHandlerService::NormalTypeHandlerService
      .new(item_type: MainHandType).handle_normal_types(event_list: EVENT_LIST)
    EventHandlerService::ItemHandlerService::NonComsumableHandlerService
      .new(item_slot: MainHand).handle_non_consumables(event_list: EVENT_LIST)
    HANDLER.new.handle_awakened_weapons(event_list: EVENT_LIST)
    HANDLER.new.handle_awakened_weapons(event_list: EVENT_LIST)
  end

  test 'Unique awakened weapon count is correct' do
    assert_difference 'AwakenedWeapon.count', 0 do
      HANDLER.new.handle_awakened_weapons(event_list: EVENT_LIST)
    end
    assert_equal AWAKENED_WEAPON[:count], AwakenedWeapon.count
  end

  test 'Unique awakened weapon trait count is correct' do
    assert_difference 'AwakenedWeaponTrait.count', 0 do
      HANDLER.new.handle_awakened_weapons(event_list: EVENT_LIST)
    end
    assert_equal TRAIT[:count], AwakenedWeaponTrait.count
  end

  test 'Stats of awakened weapons correctly saved to database' do
    record = AwakenedWeapon.find(AWAKENED_WEAPON[:id])
    assert_equal AWAKENED_WEAPON[:last_equipped].to_datetime.utc.round(6), record.last_equipped_at
    assert_equal AWAKENED_WEAPON[:attuned_player_name], Player.find(record.attuned_player_id).name
    assert_equal AWAKENED_WEAPON[:attunement], record.attunement
    assert_equal AWAKENED_WEAPON[:attunement_since_reset], record.attunement_since_reset
    assert_equal AWAKENED_WEAPON[:crafted_player_name], record.crafted_player_name
    assert_equal AWAKENED_WEAPON[:pvp_fame], record.pvp_fame
    assert_equal AWAKENED_WEAPON[:trait0], record.trait0.trait
    assert_equal AWAKENED_WEAPON[:trait1_value], record.trait1_value
    assert_equal AWAKENED_WEAPON[:trait2_roll], record.trait2_roll
  end

  test 'Stats of awakened weapon trait correctly saved to database' do
    record = AwakenedWeaponTrait.find(TRAIT[:trait])
    assert_equal TRAIT[:min_value], record.min_value
    assert_equal TRAIT[:max_value], record.max_value
  end
end
