class Api::V1::Merchants::BusinessController < ApplicationController
  
  def most_revenue
    return missing_params(['quantity']) if params[:quantity].nil? 
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  def most_items 
    return missing_params(['quantity']) if params[:quantity].nil? 
    render json: MerchantSerializer.new(Merchant.most_items(params[:quantity]))
  end

  def total_revenue
    start_date = params[:start]
    end_date = params[:end]
    unless start_date && end_date
      errors = []
      errors << 'start date' unless start_date
      errors << 'end date' unless end_date
      return missing_params(errors)
    end
    #Refactor render json: RevenueSerializer.format_revenue(Merchant.total_revenue(start_date, end_date))
    render json: RevenueSerializer.format_revenue(Api::V1::MerchantRevenueFacade.total_revenue(start_date, end_date))
  end

  def merchant_revenue 
    return missing_params(['valid merchant id']) unless Merchant.find_by(id: params[:id])
    result = Merchant.merchant_revenue(params[:id])
    revenue = 0 if result.empty? 
    revenue = result[0].revenue unless result.empty? 
    render json: RevenueSerializer.format_revenue(revenue)  
  end

  private 
    def missing_params(params)
      render json: {
        status: :bad_request,
        errors: params.map {|param| "A #{param} param is required in your query"}
      }
    end
  
end
