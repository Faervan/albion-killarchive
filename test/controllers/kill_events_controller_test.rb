# frozen_string_literal: true

require 'test_helper'

class KillEventControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get kill_event_index_url
    assert_response :success
  end

  test 'should get show' do
    get kill_event_show_url
    assert_response :success
  end
end
