# frozen_string_literal: true

module SetParamsConcern
  private

  def set_controller_params(params:, order:)
    params[:list] = begin
      Integer(params[:list])
    rescue ArgumentError, TypeError
      20
    end
    params[:order_by] = order unless params[:order_by]
    params.permit(:list, :order_by, :guild_id)
  end
end
