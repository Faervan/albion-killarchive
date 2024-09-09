# frozen_string_literal: true

class PlayersController < ApplicationController
  def index
    player = Player.includes([:guild])
    if params[:guild_id]
      player = player.where(guild_id: params[:guild_id])
      @guild_id = params[:guild_id]
    end
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'total_kill_count' unless params[:order_by]
    @players = player.order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @guilds = Guild.all
    @list = params[:list].to_i
  end

  def show
    @player = Player.find_by(name: params[:name])
    params[:list] = '20' unless params[:list]
    kill_event = KillEvent.includes(%I[kill death]).order(:timestamp).reverse_order.limit(params[:list].to_i)
    @kill_events = kill_event
                   .where(kill: { player_id: @player.player_id })
                   .or(kill_event.where(death: { player_id: @player.player_id }))
    @list = params[:list].to_i
  end
end
