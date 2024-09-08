# frozen_string_literal: true

class MainHandTypesController < ApplicationController
  def index
    params[:list] = '20' unless params[:list]
    params[:order_by] = 'usage_count' unless params[:order_by]
    @main_hand_types = MainHandType.order(params[:order_by]).reverse_order.limit(params[:list].to_i)
    @list = params[:list].to_i
  end
end
