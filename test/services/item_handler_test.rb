# frozen_string_literal: true

require 'test_helper'
Rails.root.glob('test/services/item_handlers/*.rb').each do |file|
  require file
end

class ItemHandlerTest < ActiveSupport::TestCase
end
