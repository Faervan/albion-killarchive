# frozen_string_literal: true

class AlliancesController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: :total_kill_count)
    @alliances = Alliance.order(@params[:order_by]).reverse_order.limit(@params[:list])
  end

  def show
    @params = set_controller_params(params:, order: :total_kill_count)
    @alliance = Alliance.find_by(name: params[:name])
    @guilds = Guild
              .includes([:alliance])
              .order(@params[:order_by])
              .reverse_order
              .where(alliance: @alliance)
              .limit(@params[:list])
  end
end
