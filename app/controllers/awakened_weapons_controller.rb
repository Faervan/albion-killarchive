# frozen_string_literal: true

class AwakenedWeaponsController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'pvp_fame' unless params[:order_by]
    @awakened_weapons = AwakenedWeapon.includes([:main_hand]).order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @list = params[:list].to_i
  end

  def show
    @awakened_weapon = AwakenedWeapon.find_by(awakened_weapon_id: params[:id])
  end
end
