class Api::V1::Items::ItemMerchantsController < ApplicationController
  
  def index 
    render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
  end
  
end
