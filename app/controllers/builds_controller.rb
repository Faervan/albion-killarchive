# frozen_string_literal: true

class BuildsController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'usages' unless params[:order_by]
    @builds = Build.includes(%I[main_hand_type off_hand_type head_type chest_type feet_type cape_type])
                   .order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @list = params[:list].to_i
  end

  def show
    @build = Build.find(params[:id])
  end
end
