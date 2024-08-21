# frozen_string_literal: true

class EventHandlerService::GuildHandlerService
  def handle_guilds(event_list:)
    guilds = build_guilds(event_list:)
    update_guilds(guilds:, event_list:)
    persist_guilds(guilds:)
  end

  private

  def build_guilds(event_list:)
    guilds = event_list.flat_map do |event|
      build_guild_objects(event:)
    end
    guilds.uniq
  end

  def build_guild_objects(event:)
    objects = []
    objects << build_guild_object(entity: event['Victim'])
    event['Participants'].each { |participant| objects << build_guild_object(entity: participant) }
    event['GroupMembers'].each { |member| objects << build_guild_object(entity: member) }
    objects
  end

  def build_guild_object(entity:)
    {
      guild_name: entity['GuildName'],
      guild_id: entity['GuildId'],
      alliance_id: entity['AllianceId'],
      total_kill_fame: 0,
      total_death_fame: 0,
      total_kill_count: 0,
      total_death_count: 0,
      total_assist_count: 0
    }
  end

  def update_guilds(guilds:, event_list:)
    event_list.each do |event|
      update_kill_count(guilds:, event:)
      update_kill_fame(guilds:, event:)
      update_assist_count(guilds:, event:)
      update_death_count_and_fame(guilds:, event:)
    end
  end

  def update_kill_count(guilds:, event:)
    return if event['Killer']['GuildId'] == ''

    guild = find_guild(guilds:, guild_id: event['Killer']['GuildId'])
    guild[:total_kill_count] += 1
  end

  def update_kill_fame(guilds:, event:)
    event['GroupMembers'].each do |member|
      next if member['GuildId'] == ''

      guild = find_guild(guilds:, guild_id: member['GuildId'])
      guild[:total_kill_fame] += member['KillFame']
    end
  end

  def update_assist_count(guilds:, event:)
    event['Participants'].each do |participant|
      next if participant['GuildId'] == '' || participant['Id'] == event['Killer']['Id']

      guild = find_guild(guilds:, guild_id: participant['GuildId'])
      guild[:total_assist_count] += 1
    end
  end

  def update_death_count_and_fame(guilds:, event:)
    return if event['Victim']['GuildId'] == ''

    guild = find_guild(guilds:, guild_id: event['Victim']['GuildId'])
    guild[:total_death_count] += 1
    guild[:total_death_fame] += event['TotalVictimKillFame']
  end

  def find_guild(guilds:, guild_id:)
    guilds.detect { |guild| guild[:guild_id] == guild_id }
  end

  def persist_guilds(guilds:)
    guilds.each do |guild|
      next if guild[:guild_id] == ''

      persist_guild(guild:)
      update_alliance_membership(guild:)
    end
  end

  def persist_guild(guild:)
    Guild.create!(
      set_guild_stats(guild:).merge(guild_id: guild[:guild_id])
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_guild(guild:)
  end

  def update_existing_guild(guild:)
    existing_guild = Guild.find_by(guild_id: guild[:guild_id])
    guild[:total_kill_fame] += existing_guild.total_kill_fame
    guild[:total_kill_count] += existing_guild.total_kill_count
    guild[:total_death_fame] += existing_guild.total_death_fame
    guild[:total_death_count] += existing_guild.total_death_count
    guild[:total_assist_count] += existing_guild.total_assist_count
    existing_guild.update(
      set_guild_stats(guild:)
    )
  end

  def update_alliance_membership(guild:)
    return if guild[:alliance_id] == ''

    Guild.find_by(guild_id: guild[:guild_id]).update(
      alliance_id: guild[:alliance_id]
    )
  end

  def set_guild_stats(guild:)
    {
      name: guild[:guild_name],
      total_kill_fame: guild[:total_kill_fame],
      total_death_fame: guild[:total_death_fame],
      total_kill_count: guild[:total_kill_count],
      total_death_count: guild[:total_death_count],
      total_assist_count: guild[:total_assist_count],
      kd_perc:
        begin
          (100.0 / (guild[:total_kill_count] + guild[:total_death_count]) * guild[:total_kill_count] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
