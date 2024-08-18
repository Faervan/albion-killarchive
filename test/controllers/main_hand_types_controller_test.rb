# frozen_string_literal: true

require 'test_helper'

class MainHandTypesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get main_hand_types_index_url
    assert_response :success
  end
end
