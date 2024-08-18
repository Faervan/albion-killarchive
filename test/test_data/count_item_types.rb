# frozen_string_literal: true

require 'json'

if ARGV[0].nil?
  puts "Needs an item category argument! e.g. 'MainHand'"
  exit 1
end

event_list = File.read('event_list.json')
event_list = JSON.parse(event_list)

class String
  def parse_type
    match(/(?:T[1-8])?(?:_)?(?:2H_)?(?<item_name>[^@]*)(?:@[0-4])?/)[:item_name]
  end
end

item_types = []

def item_exists?(entity)
  !entity['Equipment'][ARGV[0]].nil?
end

event_list.each do |event|
  item_types << event['Killer']['Equipment'][ARGV[0]]['Type'].parse_type if item_exists?(event['Killer'])
  item_types << event['Victim']['Equipment'][ARGV[0]]['Type'].parse_type if item_exists?(event['Victim'])
  event['Participants'].each do |p|
    item_types << p['Equipment'][ARGV[0]]['Type'].parse_type if item_exists?(p)
  end
  event['GroupMembers'].each do |p|
    item_types << p['Equipment'][ARGV[0]]['Type'].parse_type if item_exists?(p)
  end
end

pp item_types.uniq
puts item_types.uniq.count
