class Api::V1::Merchants::BusinessController < ApplicationController
  
  def most_revenue
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  def most_items 
    render json: MerchantSerializer.new(Merchant.most_items(params[:quantity]))
  end
  
end
