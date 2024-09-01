# frozen_string_literal: true

require 'test_helper'

class AwakenedWeaponsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get awakened_weapons_path
    assert_response :success
  end

  test 'should get show' do
    get awakened_weapons_path
    assert_response :success
  end
end
