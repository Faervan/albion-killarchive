# frozen_string_literal: true

class EventHandlerService::AvatarRingHandlerService
  def handle_avatar_rings(event_list:)
    avatar_rings = build_avatar_rings(event_list:)
    persist_avatar_rings(avatar_rings:)
  end

  private

  def build_avatar_rings(event_list:)
    avatar_rings = []
    event_list.each do |event|
      avatar_rings << event['Victim']['AvatarRing']
      event['Participants'].each { |participant| avatar_rings << participant['AvatarRing'] }
      event['GroupMembers'].each { |member| avatar_rings << member['AvatarRing'] }
    end
    avatar_rings.uniq
  end

  def persist_avatar_rings(avatar_rings:)
    avatar_rings.each do |avatar_ring|
      persist_avatar_ring(avatar_ring:) unless AvatarRing.find_by(avatar_ring_id: avatar_ring)
    end
  end

  def persist_avatar_ring(avatar_ring:)
    AvatarRing.create!(avatar_ring_id: avatar_ring)
  end
end
