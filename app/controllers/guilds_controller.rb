# frozen_string_literal: true

class GuildsController < ApplicationController
  include SetParamsConcern
  before_action -> { set_controller_params(params:, order: 'total_kill_count') }

  def index
    guild = Guild.includes([:alliance])
    if params[:alliance_id]
      guild = guild.where(alliance_id: params[:alliance_id])
      @alliance_id = params[:alliance_id]
    end
    @guilds = guild.order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @alliances = Alliance.all
    @params = params
  end

  def show
    @guild = Guild.find_by(name: params[:name])
    @players = Player
               .includes([:guild])
               .order('total_kill_count')
               .reverse_order
               .where(guild: @guild)
               .limit(params[:list].to_i)
    @params = params
  end
end
