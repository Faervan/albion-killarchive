# frozen_string_literal: true

require 'test_helper'

class BuildsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get builds_path
    assert_response :success
  end
end
