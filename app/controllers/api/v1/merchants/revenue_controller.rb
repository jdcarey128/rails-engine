class Api::V1::Merchants::RevenueController < ApplicationController
  def total_revenue
    start_date = params[:start]
    end_date = params[:end]
    unless start_date && end_date
      errors = []
      errors << 'start date' unless start_date
      errors << 'end date' unless end_date
      return params_error(errors)
    end
    render json: RevenueSerializer.format_revenue(Api::V1::MerchantRevenueFacade.total_revenue(start_date, end_date))
  end

  private 
    def params_error(errors)
      render json: {
        status: :bad_request,
        errors: errors.map {|param| "A #{param} param is required in your query"}
      }
    end 
end
