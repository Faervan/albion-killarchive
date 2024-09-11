# frozen_string_literal: true

class MainHandTypesController < ApplicationController
  include SetParamsConcern

  def index
    @params = set_controller_params(params:, order: :usage_count)
    @main_hand_types = MainHandType.order(@params[:order_by]).reverse_order.limit(@params[:list])
  end
end
