# frozen_string_literal: true

class KillEventsController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: :timestamp)
    @kill_events = KillEvent.includes(%I[kill death]).order({ @params[:order_by].to_sym => :desc }).limit(@params[:list])
  end

  def show; end
end
