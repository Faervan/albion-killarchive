# frozen_string_literal: true

class AlliancesController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'total_kill_count' unless params[:order_by]
    @alliances = Alliance.order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @list = params[:list].to_i
  end

  def show
    params[:list] = '20' unless params[:list]
    @alliance = Alliance.find(params[:id])
    @guilds = Guild
              .includes([:alliance])
              .order('total_kill_count')
              .reverse_order
              .where(alliance: @alliance)
              .limit(params[:list].to_i)
    @list = params[:list].to_i
  end
end
