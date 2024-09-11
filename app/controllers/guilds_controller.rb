# frozen_string_literal: true

class GuildsController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: :total_kill_count)
    guild = Guild.includes([:alliance])
    guild = guild.where(alliance_id: params[:alliance_id]) if params[:alliance_id]
    @guilds = guild.order(@params[:order_by]).reverse_order.limit(@params[:list])
  end

  def show
    @params = set_controller_params(params:, order: :total_kill_count)
    @guild = Guild.find_by(name: params[:name])
    @players = Player
               .includes([:guild])
               .order(@params[:order_by])
               .reverse_order
               .where(guild: @guild)
               .limit(@params[:list])
  end
end
