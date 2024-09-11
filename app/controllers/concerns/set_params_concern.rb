# frozen_string_literal: true

module SetParamsConcern
  private

  def set_controller_params(params:, order:)
    param_list = {
      list: begin
        Integer(params[:list])
      rescue ArgumentError, TypeError
        20
      end,
      order_by: params[:order_by].nil? ? order : params[:order_by]
    }
    param_list[:guild_id] = params[:guild_id]
    param_list
  end
end
