# frozen_string_literal: true

class EventHandlerService::ItemTypeHandlerService::FoodTypeHandlerService
  def handle_food_types(event_list:)
    food_types = build_food_types(event_list:)
    update_food_types(food_types:, event_list:)
    persist_food_types(food_types:)
  end

  private

  def build_food_types(event_list:)
    food_types = event_list.flat_map do |event|
      build_food_type_objects(event:)
    end
    food_types.uniq
  end

  def build_food_type_objects(event:)
    objects = []
    objects << build_food_type_object(entity: event['Killer']) if food_exists?(entity: event['Killer'])
    objects << build_food_type_object(entity: event['Victim']) if food_exists?(entity: event['Victim'])
    event['Participants'].each do |participant|
      objects << build_food_type_object(entity: participant) if food_exists?(entity: participant)
    end
    event['GroupMembers'].each do |member|
      objects << build_food_type_object(entity: member) if food_exists?(entity: member)
    end
    objects
  end

  def build_food_type_object(entity:)
    {
      path: entity['Equipment']['Food']['Type'].parse_item_type,
      total_ip: 0,
      kills: 0,
      deaths: 0,
      assists: 0
    }
  end

  def food_exists?(entity:)
    !entity['Equipment']['Food'].nil?
  end

  def update_food_types(food_types:, event_list:)
    event_list.each do |event|
      update_kills_and_ip(food_types:, event:)
      update_deaths_and_ip(food_types:, event:)
      update_assists_and_ip(food_types:, event:)
    end
  end

  def update_kills_and_ip(food_types:, event:)
    return unless food_exists?(entity: event['Killer'])

    food_type = find_food_type(food_types:, entity: event['Killer'])
    food_type[:kills] += 1
    food_type[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_deaths_and_ip(food_types:, event:)
    return unless food_exists?(entity: event['Victim'])

    food_type = find_food_type(food_types:, entity: event['Victim'])
    food_type[:deaths] += 1
    food_type[:total_ip] += event['Victim']['AverageItemPower']
  end

  def update_assists_and_ip(food_types:, event:)
    event['Participants'].each do |participant|
      next if !food_exists?(entity: participant) || participant['Id'] == event['Killer']['Id']

      food_type = find_food_type(food_types:, entity: participant)
      food_type[:assists] += 1
      food_type[:total_ip] += participant['AverageItemPower']
    end
  end

  def find_food_type(food_types:, entity:)
    food_types.detect { |a| a[:path] == entity['Equipment']['Food']['Type'].parse_item_type }
  end

  def persist_food_types(food_types:)
    food_types.each do |food_type|
      next if food_type[:path] == ''

      persist_food_type(food_type:)
    end
  end

  def persist_food_type(food_type:)
    FoodType.create!(
      set_food_type_stats(food_type:).merge({ path: food_type[:path] })
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_food_type(food_type:)
  end

  def update_existing_food_type(food_type:)
    existing_food_type = FoodType.find_by(path: food_type[:path])
    food_type[:kills] += existing_food_type.kills
    food_type[:deaths] += existing_food_type.deaths
    food_type[:assists] += existing_food_type.assists
    food_type[:total_ip] += existing_food_type.total_ip
    existing_food_type.update(
      set_food_type_stats(food_type:)
    )
  end

  def set_food_type_stats(food_type:)
    usages = food_type[:kills] + food_type[:deaths] + food_type[:assists]
    {
      kills: food_type[:kills],
      deaths: food_type[:deaths],
      assists: food_type[:assists],
      usages:,
      total_ip: food_type[:total_ip],
      avg_ip:
        begin
          food_type[:total_ip] / usages
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          (100.0 / (food_type[:kills] + food_type[:deaths]) * food_type[:kills] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
