# frozen_string_literal: true

require 'test_helper'

class GuildsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get guilds_path
    assert_response :success
  end
end
