# frozen_string_literal: true

require 'test_helper'

class KillEventHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  KILL_EVENT = {
    kill_event_id: 50_124_542,
    total_fame: 108_240,
    assist_count: 2,
    ally_count: 3,
    passive_assist_count: 2,
    kill: {
      player_id: 'JpAYr2W9Q8-OluErv0dR6Q',
      main_hand_path: 'T6_2H_SHAPESHIFTER_MORGANA@2_Q4',
      avg_ip: 1_355,
      kill_fame: 27_060,
      damage: 1_535,
      healing: 0
    },
    death: {
      player_id: 'v09hyja7QBqUXfdQ6mC_bg',
      head_path: 'T4_HEAD_LEATHER_SET2@1_Q4',
      avg_ip: 1_031,
      death_fame: 108_240
    },
    assist: {
      player_id: 'W_pdO070RvmXqBsSCOJUtg',
      food_path: 'T7_MEAL_OMELETTE@0',
      avg_ip: 1_223,
      kill_fame: 27_060,
      damage: 31,
      healing: 0,
      ally?: true
    },
    passive_assist: {
      player_id: 'nbElSP61QxCmsez0vFSnjg',
      main_hand_path: 'T6_MAIN_CURSEDSTAFF@1_Q3',
      kill_fame: 27_060
    }
  }.freeze

  setup do
    EventHandlerService.new.persist_events(EVENT_LIST)
  end

  test 'Unique KillEvent count is correct' do
    assert_equal 20, KillEvent.count
  end

  test 'Stats of KillEvent correctly saved to database' do
    kill_event = KillEvent.find(KILL_EVENT[:kill_event_id])
    assert_equal KILL_EVENT[:total_fame], kill_event.total_fame
    assert_equal KILL_EVENT[:assist_count], kill_event.assist_count
    assert_equal KILL_EVENT[:ally_count], kill_event.ally_count
    assert_equal KILL_EVENT[:passive_assist_count], kill_event.passive_assist_count
    check_kill(kill_event)
    check_death(kill_event)
    check_assist(kill_event)
    check_passive_assist(kill_event)
  end

  private

  def check_kill(kill_event)
    [KILL_EVENT[:kill], kill_event.kill].tap do |e, r|
      assert_equal e[:player_id], r.player_id
      assert_equal e[:main_hand_path], r.main_hand_path
      assert_equal e[:avg_ip], r.avg_ip
      assert_equal e[:kill_fame], r.kill_fame
      assert_equal e[:damage], r.damage
      assert_equal e[:healing], r.healing
    end
  end

  def check_death(kill_event)
    [KILL_EVENT[:death], kill_event.death].tap do |e, r|
      assert_equal e[:player_id], r.player_id
      assert_equal e[:head_path], r.head_path
      assert_equal e[:avg_ip], r.avg_ip
      assert_equal e[:death_fame], r.death_fame
    end
  end

  def check_assist(kill_event)
    [KILL_EVENT[:assist], kill_event.assists.find_by(player_id: KILL_EVENT[:assist][:player_id])].tap do |e, r|
      assert_equal e[:food_path], r.food_path
      assert_equal e[:avg_ip], r.avg_ip
      assert_equal e[:kill_fame], r.kill_fame
      assert_equal e[:damage], r.damage
      assert_equal e[:healing], r.healing
      assert_equal e[:ally?], r.ally?
    end
  end

  def check_passive_assist(kill_event)
    [KILL_EVENT[:passive_assist], kill_event.passive_assists.find_by(player_id: KILL_EVENT[:passive_assist][:player_id])]
      .tap do |e, r|
      assert_equal e[:main_hand_path], r.main_hand_path
      assert_equal e[:kill_fame], r.kill_fame
    end
  end
end
