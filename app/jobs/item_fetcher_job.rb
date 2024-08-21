# frozen_string_literal: true

require 'down'

class ItemFetcherJob < ApplicationJob
  queue_as :low_priority

  def perform(base_path:, quality:, enchantment:, tier:, model:)
    path = "T#{tier}_#{base_path}"
    full_path = "#{path}@#{enchantment}_Q#{quality}"
    save_item_name(path:, full_path:, model:)
    save_item_image(path:, quality:, enchantment:, full_path:, model: model.table_name)
    compress_item_image(full_path:, model: model.table_name)
  end

  private

  def save_item_name(path:, full_path:, model:)
    name = HTTParty.get("https://gameinfo.albiononline.com/api/gameinfo/items/#{path}/data")['localizedNames']['EN-US']
    model.find_by(path: full_path).update!(name:)
  end

  def save_item_image(path:, quality:, enchantment:, full_path:, model:)
    img_url = "https://render.albiononline.com/v1/item/#{path}@#{enchantment}.png?quality=#{quality}"
    img_save_path = Rails.root.join("app/assets/images/217x217/#{model}/#{full_path}.png")
    Down.download(img_url, destination: img_save_path)
  end

  def compress_item_image(full_path:, model:)
    input = Rails.root.join("app/assets/images/217x217/#{model}/#{full_path}.png")
    output = Rails.root.join("app/assets/images/50x50/#{model}")

    system("mogrify -path #{output} -filter Triangle -define filter:support=2 -thumbnail 100 -unsharp 0.25x0.25+8+0.065 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB -strip #{input}") # rubocop:disable Metric/LineLength
  end
end
