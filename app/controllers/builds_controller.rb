# frozen_string_literal: true

class BuildsController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'usages' unless params[:order_by]
    @builds = Build.includes(%I[main_hand_type off_hand_type head_type chest_type feet_type cape_type])
    secondary_order = order_by_specs(order_by: params[:order_by])
    @builds = @builds.order({ params[:order_by].to_sym => :desc }.merge(secondary_order)).limit(params[:list].to_i)
    @list = params[:list].to_i
  end

  def show
    @build = Build.find(params[:id])
  end

  private

  def order_by_specs(order_by:)
    secondary_order = {}
    case order_by
    when 'usages'
      secondary_order.merge!(kills: :desc)
    when 'kd_perc'
      @builds = @builds.where.not(kd_perc: nil)
      secondary_order.merge!(kills: :desc)
    when 'fame_ratio'
      @builds = @builds.where.not(fame_ratio: nil)
    when 'avg_ip'
      secondary_order.merge!(usages: :desc)
    when 'avg_ip_diff'
      @builds = @builds.where.not(avg_ip_diff: nil)
      secondary_order.merge!(usages: :desc)
    end
    secondary_order
  end
end
