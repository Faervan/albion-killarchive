# frozen_string_literal: true

class BuildsController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: 'usage_count')
    @builds = Build
    secondary_order = order_by_specs(order_by: @params[:order_by])
    @builds = @builds.order({ @params[:order_by].to_sym => :desc }.merge(secondary_order)).limit(@params[:list])
  end

  def show
    @params = set_controller_params(params:, order: :timestamp)
    @build = Build.find(params[:id])
    kill_event = KillEvent.includes(%I[kill death]).order(@params[:order_by]).reverse_order
    kill_events = kill_event
                  .where(kill: { build_id: @build.id })
                  .or(kill_event.where(death: { build_id: @build.id }))
    @kill_events = kill_events.limit(@params[:list])
  end

  private

  def order_by_specs(order_by:)
    secondary_order = {}
    case order_by
    when 'usage_count'
      secondary_order.merge!(kill_count: :desc)
    when 'kd_perc'
      @builds = @builds.where.not(kd_perc: nil)
      secondary_order.merge!(kill_count: :desc)
    when 'fame_ratio'
      @builds = @builds.where.not(fame_ratio: nil)
    when 'avg_ip'
      secondary_order.merge!(usage_count: :desc)
    when 'avg_ip_diff'
      @builds = @builds.where.not(avg_ip_diff: nil)
      secondary_order.merge!(usage_count: :desc)
    end
    secondary_order
  end
end
