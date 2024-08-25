# frozen_string_literal: true

require 'down'
require 'shellwords'

class ItemFetcherJob < ApplicationJob
  queue_as :low_priority

  def perform(path:,
              model:,
              quality: 4,
              enchantment: 0,
              with_name: false,
              with_base_ip: false,
              is_consumable: false)
    full_path = "#{path}@#{enchantment}" + (is_consumable ? '' : "_Q#{quality}")
    save_item_image(path:, quality:, enchantment:, full_path:, model: model.table_name) unless Rails.env.test?
    save_item_name(path:, full_path:, model:) if with_name
    save_base_ip(path: path.parse_item_type[:path], model:) if with_base_ip
  end

  private

  def save_item_name(path:, full_path:, model:)
    name = HTTParty.get("https://gameinfo.albiononline.com/api/gameinfo/items/#{path}/data")['localizedNames']['EN-US']
    model.find(full_path).update!(name:)
  end

  def save_base_ip(path:, model:)
    base_ip = HTTParty.get("https://gameinfo.albiononline.com/api/gameinfo/items/T4_#{path}/data")['itemPower'].to_i
    "#{model}Type".constantize.find_by(path:).update!(base_ip:)
  end

  def save_item_image(path:, quality:, enchantment:, full_path:, model:)
    img_url = "https://render.albiononline.com/v1/item/#{path}@#{enchantment}.png?quality=#{quality}"
    img_save_path = Rails.root.join("app/assets/images/217x217/#{model}/#{full_path}.png")
    Down.download(img_url, destination: img_save_path) unless File.exist?(img_save_path)
    return if Rails.root.join("app/assets/images/100x100/#{model}/#{full_path}.png").exist?

    compress_item_image(full_path:,
                        model:)
  end

  def compress_item_image(full_path:, model:)
    input = Rails.root.join("app/assets/images/217x217/#{model}/#{full_path}.png")
    output = Rails.root.join("app/assets/images/100x100/#{model}")

    system("mogrify -path #{Shellwords.escape(output)} -filter Triangle -define filter:support=2 -thumbnail 100 -unsharp 0.25x0.25+8+0.065 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB -strip #{Shellwords.escape(input)}") # rubocop:disable Metric/LineLength
  end
end
