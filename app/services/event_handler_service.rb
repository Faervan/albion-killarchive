# frozen_string_literal: true

class EventHandlerService
  def persist_events(event_list)
    AllianceHandlerService.new.handle_alliances(event_list:)
    GuildHandlerService.new.handle_guilds(event_list:)
    AvatarHandlerService.new.handle_avatars(event_list:)
  end
end
