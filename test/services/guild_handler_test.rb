# frozen_string_literal: true

require 'test_helper'

class GuildHandlerTest < ActiveSupport::TestCase
  EVENT_LIST = JSON.parse File.read('test/test_data/event_list.json')
  FIRST_GUILD_NAME = 'Die Schwarzen Engel'
  FIRST_GUILD_ID = '-0Pu27dRRKCYS6aTh1fgug'
  FIRST_GUILD_TOTAL_KILL_FAME = 162_360
  FIRST_GUILD_TOTAL_KILL_COUNT = 2
  FIRST_GUILD_TOTAL_ASSIST_COUNT = 2
  SECOND_GUILD_NAME = 'Error404'
  SECOND_GUILD_ID = 'UCLmBccEQ4W6kksAWwxMXA'
  SECOND_GUILD_TOTAL_DEATH_FAME = 216_480
  SECOND_GUILD_TOTAL_DEATH_COUNT = 2
  SECOND_GUILD_TOTAL_ASSIST_COUNT = 0

  setup do
    EventHandlerService::AllianceHandlerService.new.handle_alliances(event_list: EVENT_LIST)
  end

  test 'Unique guild count is 37' do
    assert_difference 'Guild.count', 37 do
      EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
      EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    end
  end

  test 'First event\'s data correctly saved to database' do
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    assert_equal SECOND_GUILD_ID, Guild.first.guild_id
    assert_equal SECOND_GUILD_NAME, Guild.first.name
  end

  test "Stats of guilds #{FIRST_GUILD_NAME} and #{SECOND_GUILD_NAME} correctly saved to database" do
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    EventHandlerService::GuildHandlerService.new.handle_guilds(event_list: EVENT_LIST)
    assert_equal FIRST_GUILD_TOTAL_KILL_FAME, Guild.find_by(name: FIRST_GUILD_NAME).total_kill_fame
    assert_equal FIRST_GUILD_TOTAL_KILL_COUNT, Guild.find_by(name: FIRST_GUILD_NAME).total_kill_count
    assert_equal FIRST_GUILD_TOTAL_ASSIST_COUNT, Guild.find_by(name: FIRST_GUILD_NAME).total_assist_count
    assert_equal SECOND_GUILD_TOTAL_DEATH_FAME, Guild.find_by(name: SECOND_GUILD_NAME).total_death_fame
    assert_equal SECOND_GUILD_TOTAL_DEATH_COUNT, Guild.find_by(name: SECOND_GUILD_NAME).total_death_count
    assert_equal SECOND_GUILD_TOTAL_ASSIST_COUNT, Guild.find_by(name: SECOND_GUILD_NAME).total_assist_count
  end
end
