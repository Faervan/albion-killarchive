# frozen_string_literal: true

class EventHandlerService::AvatarHandlerService
  def handle_avatars(event_list:)
    avatars = build_avatars(event_list:)
    persist_avatars(avatars:)
  end

  private

  def build_avatars(event_list:)
    avatars = []
    event_list.each do |event|
      avatars << event['Victim']['Avatar']
      event['Participants'].each { |participant| avatars << participant['Avatar'] }
      event['GroupMembers'].each { |member| avatars << member['Avatar'] }
    end
    avatars.uniq
  end

  def persist_avatars(avatars:)
    avatars.each do |avatar|
      persist_avatar(avatar:) unless Avatar.find_by(avatar_id: avatar)
    end
  end

  def persist_avatar(avatar:)
    Avatar.create!(avatar_id: avatar)
  end
end
