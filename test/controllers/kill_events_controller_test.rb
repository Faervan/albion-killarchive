# frozen_string_literal: true

require 'test_helper'

class KillEventControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get kill_events_path
    assert_response :success
  end
end
