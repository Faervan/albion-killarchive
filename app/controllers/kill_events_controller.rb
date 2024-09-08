# frozen_string_literal: true

class KillEventsController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'timestamp' unless params[:order_by]
    @kill_events = KillEvent.includes(%I[kill death]).order({ params[:order_by].to_sym => :desc }).limit(params[:list].to_i)
    @list = params[:list].to_i
  end

  def show; end
end
