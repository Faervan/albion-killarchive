# frozen_string_literal: true

require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get players_path
    assert_response :success
  end
end
