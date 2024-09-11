# frozen_string_literal: true

class PlayersController < ApplicationController
  include SetParamsConcern
  before_action -> { set_controller_params(params:, order: 'total_kill_count') }, only: [:index]
  before_action -> { set_controller_params(params:, order: :timestamp) }, only: [:show]

  def index
    player = Player.includes([:guild])
    if params[:guild_id]
      player = player.where(guild_id: params[:guild_id])
      @guild_id = params[:guild_id]
    end
    @players = player.order(params[:order_by]).reverse_order.limit(params[:list])
    @guilds = Guild.all
    @params = set_controller_params(params:, order: 'total_kill_count')
  end

  def show
    @player = Player.find_by(name: params[:name])
    kill_event = KillEvent.includes(%I[kill death]).order(:timestamp).reverse_order.limit(params[:list].to_i)
    @kill_events = kill_event
                   .where(kill: { player_id: @player.player_id })
                   .or(kill_event.where(death: { player_id: @player.player_id }))
  end
end
