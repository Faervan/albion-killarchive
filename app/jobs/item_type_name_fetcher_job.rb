# frozen_string_literal: true

require 'down'

class ItemTypeNameFetcherJob < ApplicationJob
  queue_as :low_priority

  def perform(model:, path:)
    save_item_name(model:, path:)
  end

  private

  def save_item_name(model:, path:)
    name = HTTParty.get("https://gameinfo.albiononline.com/api/gameinfo/items/T4_#{path}/data")['localizedNames']['EN-US']
                   .delete_prefix('Adept\'s ')
    model.find(path).update!(name:)
  end
end
