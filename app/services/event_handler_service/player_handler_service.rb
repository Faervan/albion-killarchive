# frozen_string_literal: true

class EventHandlerService::PlayerHandlerService
  def handle_players(event_list:)
    players = build_players(event_list:)
    update_players(players:, event_list:)
    persist_players(players:)
  end

  private

  def build_players(event_list:)
    players = event_list.flat_map do |event|
      build_player_objects(event:)
    end
    players.uniq
  end

  def build_player_objects(event:)
    objects = []
    objects << build_player_object(entity: event['Victim'])
    event['Participants'].each { |participant| objects << build_player_object(entity: participant) }
    event['GroupMembers'].each { |member| objects << build_player_object(entity: member) }
    objects
  end

  def build_player_object(entity:)
    {
      name: entity['Name'],
      player_id: entity['Id'],
      guild_id: entity['GuildId'],
      avatar_id: entity['Avatar'],
      avatar_ring_id: entity['AvatarRing'],
      stalker_rating: 0,
      slayer_rating: 0,
      duo_rating: 0,
      total_kill_fame: 0,
      total_death_fame: 0,
      total_kill_count: 0,
      total_death_count: 0,
      total_assist_count: 0,
      total_ip: 0
    }
  end

  def update_players(players:, event_list:)
    event_list.each do |event|
      update_kill_count(players:, event:)
      update_kill_fame(players:, event:)
      update_assist_count(players:, event:)
      update_death_count_and_fame(players:, event:)
    end
  end

  def update_kill_count(players:, event:)
    player = find_player(players:, player_id: event['Killer']['Id'])
    player[:total_kill_count] += 1
    player[:total_ip] += event['Killer']['AverageItemPower']
  end

  def update_kill_fame(players:, event:)
    event['GroupMembers'].each do |member|
      player = find_player(players:, player_id: member['Id'])
      player[:total_kill_fame] += member['KillFame']
    end
  end

  def update_assist_count(players:, event:)
    event['Participants'].each do |participant|
      next if participant['Id'] == event['Killer']['Id']

      player = find_player(players:, player_id: participant['Id'])
      player[:total_assist_count] += 1
      player[:total_ip] += participant['AverageItemPower']
    end
  end

  def update_death_count_and_fame(players:, event:)
    player = find_player(players:, player_id: event['Victim']['Id'])
    player[:total_death_count] += 1
    player[:total_death_fame] += event['TotalVictimKillFame']
    player[:total_ip] += event['Victim']['AverageItemPower']
  end

  def find_player(players:, player_id:)
    players.detect { |player| player[:player_id] == player_id }
  end

  def persist_players(players:)
    players.each do |player|
      persist_player(player:)
      update_guild_membership(player:)
    end
  end

  def persist_player(player:)
    Player.create!(
      set_player_stats(player:).merge(player_id: player[:player_id])
    )
  rescue ActiveRecord::RecordNotUnique
    update_existing_player(player:)
  end

  def update_existing_player(player:)
    existing_player = Player.find_by(player_id: player[:player_id])
    player[:stalker_rating] += existing_player.stalker_rating
    player[:slayer_rating] += existing_player.slayer_rating
    player[:duo_rating] += existing_player.duo_rating
    player[:total_kill_fame] += existing_player.total_kill_fame
    player[:total_kill_count] += existing_player.total_kill_count
    player[:total_death_fame] += existing_player.total_death_fame
    player[:total_death_count] += existing_player.total_death_count
    player[:total_assist_count] += existing_player.total_assist_count
    player[:total_ip] += existing_player.total_ip
    existing_player.update(
      set_player_stats(player:)
    )
  end

  def update_guild_membership(player:)
    return if player[:guild_id] == ''

    Player.find_by(player_id: player[:player_id]).update(
      guild_id: player[:guild_id]
    )
  end

  def set_player_stats(player:)
    {
      name: player[:name],
      stalker_rating: player[:stalker_rating],
      slayer_rating: player[:slayer_rating],
      duo_rating: player[:duo_rating],
      total_kill_fame: player[:total_kill_fame],
      total_death_fame: player[:total_death_fame],
      total_kill_count: player[:total_kill_count],
      total_death_count: player[:total_death_count],
      total_assist_count: player[:total_assist_count],
      avatar_id: player[:avatar_id],
      avatar_ring_id: player[:avatar_ring_id],
      total_ip: player[:total_ip],
      avg_ip:
        begin
          player[:total_ip] / (player[:total_kill_count] + player[:total_death_count] + player[:total_assist_count])
        rescue ZeroDivisionError
          0
        end,
      kd_perc:
        begin
          (100.0 / (player[:total_kill_count] + player[:total_death_count]) * player[:total_kill_count] * 100).round
        rescue ZeroDivisionError, FloatDomainError
          0
        end
    }
  end
end
