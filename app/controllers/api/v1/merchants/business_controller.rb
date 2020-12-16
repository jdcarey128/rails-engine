class Api::V1::Merchants::BusinessController < ApplicationController
  
  def most_revenue
    return missing_params(['quantity']) if params[:quantity].nil? 
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  def most_items 
    return missing_params(['quantity']) if params[:quantity].nil? 
    render json: MerchantSerializer.new(Merchant.most_items(params[:quantity]))
  end

  private 
    def missing_params(params)
      render json: {
        status: :bad_request,
        errors: params.map {|param| "A #{param} param is required in your query"}
      }
    end
  
end
