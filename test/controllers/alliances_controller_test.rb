# frozen_string_literal: true

require 'test_helper'

class AlliancesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get alliances_path
    assert_response :success
  end
end
