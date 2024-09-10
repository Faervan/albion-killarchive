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
    death: {},
    assist: {},
    passive_assist: {}
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
    tap KILL_EVENT[:kill] do |k|
      assert_equal k[:player_id], kill_event.kill.player_id
      assert_equal k[:main_hand_path], kill_event.kill.main_hand_path
    end
  end
end
