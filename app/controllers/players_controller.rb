# frozen_string_literal: true

class PlayersController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: :total_kill_count)
    player = Player.includes([:guild])
    if params[:guild_id]
      player = player.where(guild_id: @params[:guild_id])
      @guild_id = params[:guild_id]
    end
    @players = player.order(@params[:order_by]).reverse_order.limit(@params[:list])
    @guilds = Guild.all
  end

  def show
    @params = set_controller_params(params:, order: :timestamp)
    @player = Player.find_by(name: params[:name])
    kill_event = KillEvent.includes(%I[kill death]).order(@params[:order_by]).reverse_order
    kill_events = kill_event
                  .where(kill: { player_id: @player.player_id })
                  .or(kill_event.where(death: { player_id: @player.player_id }))
    @kill_events = kill_events.limit(@params[:list])
  end
end
