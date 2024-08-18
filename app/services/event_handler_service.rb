# frozen_string_literal: true

class EventHandlerService
  def persist_events(event_list)
    AllianceHandlerService.new.handle_alliances(event_list:)
    GuildHandlerService.new.handle_guilds(event_list:)
    AvatarHandlerService.new.handle_avatars(event_list:)
    AvatarRingHandlerService.new.handle_avatar_rings(event_list:)
    PlayerHandlerService.new.handle_players(event_list:)
    ItemTypeHandlerService.new.handle_item_types(event_list:)
  end
end
