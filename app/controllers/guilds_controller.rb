# frozen_string_literal: true

class GuildsController < ApplicationController
  def index
    guild = Guild
    if params[:alliance_id]
      guild = guild.where(alliance_id: params[:alliance_id])
      @alliance_id = params[:alliance_id]
    end
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'total_kill_count' unless params[:order_by]
    @guilds = guild.order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @alliances = Alliance.all
    @list = params[:list].to_i
  end
end
